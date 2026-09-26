# Patterns for tricky placement cases

Worked examples. Paths assume the default structure from SKILL.md; adapt names to the project's conventions.

## Contents
1. Two features need to meet
2. Hook or pure function?
3. Business rule scattered across components
4. Boolean props explosion → composition
5. Query key / options factory per feature
6. Constants at the right level
7. API DTO vs UI type
8. Thin Server Action + service (Next.js)
9. Client wrapper around server content (Next.js)

## 1. Two features need to meet

`products` shows a product; `cart` owns "add to cart". `products` must not import `cart`. Compose one level up, passing the cart piece as a slot:

```tsx
// app/(shop)/product/[id]/page.tsx
import { ProductDetails } from '@/features/products/components/product-details'
import { AddToCartButton } from '@/features/cart/components/add-to-cart-button'

export default async function ProductPage({ params }: PageProps<'/product/[id]'>) {
  const { id } = await params
  return <ProductDetails id={id} actions={<AddToCartButton productId={id} />} />
}
```

```tsx
// features/products/components/product-details.tsx
export function ProductDetails({ id, actions }: { id: string; actions?: React.ReactNode }) {
  // …renders product, knows nothing about the cart
  return <section>{/* … */}{actions}</section>
}
```

If both features need the same *data model* (e.g. `Product` type, price formatting), move that piece down into a shared/entity layer instead.

## 2. Hook or pure function?

```ts
// features/cart/domain/pricing.ts — business rule, no React
export function calculateTotal(items: CartItem[], discount: Discount | null): number {
  const subtotal = items.reduce((sum, i) => sum + i.price * i.qty, 0)
  return discount ? applyDiscount(subtotal, discount) : subtotal
}

// features/cart/hooks/use-cart-total.ts — glue: calls hooks, delegates the rule
export function useCartTotal() {
  const { data: items = [] } = useQuery(cartQueries.items())
  const discount = useActiveDiscount()
  return calculateTotal(items, discount)
}
```

`calculateTotal` is unit-tested with plain data and reusable on the server. A function named `useFormattedPrice` that calls no hooks should be renamed `formatPrice` and moved to `utils`.

## 3. Business rule scattered across components

Before: `if (order.status === 'paid' && daysSince(order.paidAt) < 14)` in three components.

```ts
// features/orders/domain/order-rules.ts
const REFUND_WINDOW_DAYS = 14

export function canRequestRefund(order: Order, now = new Date()): boolean {
  return order.status === 'paid' && daysBetween(order.paidAt, now) < REFUND_WINDOW_DAYS
}
```

Components call `canRequestRefund(order)`. For per-variant rules (country, plan), use a lookup/strategy object in `domain/` instead of spreading `switch` statements:

```ts
const paymentRules: Record<Country, PaymentRules> = {
  JP: { roundTo: 1, methods: ['card', 'konbini'] },
  DK: { roundTo: 0.01, methods: ['card', 'mobilepay'] },
}
```

## 4. Boolean props explosion → composition

```tsx
// ❌ grows forever
<Card title="…" showFooter isCompact withActions onEdit={…} />

// ✅ compound components
<Card>
  <Card.Header>Invoice #12</Card.Header>
  <Card.Body>…</Card.Body>
  <Card.Footer><EditButton /></Card.Footer>
</Card>
```

In Next.js, if Server Components use the parts, export them as named exports (`CardHeader`) — static members don't survive the client boundary.

## 5. Query key / options factory per feature

```ts
// features/todos/api/todo-queries.ts
import { queryOptions } from '@tanstack/react-query'
import { fetchTodos, fetchTodo } from './todo-api'

export const todoQueries = {
  all: () => ['todos'] as const,
  lists: () => [...todoQueries.all(), 'list'] as const,
  list: (filters: TodoFilters) =>
    queryOptions({ queryKey: [...todoQueries.lists(), filters], queryFn: () => fetchTodos(filters) }),
  detail: (id: string) =>
    queryOptions({ queryKey: [...todoQueries.all(), 'detail', id], queryFn: () => fetchTodo(id) }),
}

// component
const { data } = useQuery(todoQueries.list(filters))
// invalidation
queryClient.invalidateQueries({ queryKey: todoQueries.lists() })
```

Keys and fetchers live together per feature; no global `queryKeys.ts`.

## 6. Constants at the right level

```tsx
// used only here → module scope of the component file
const MAX_VISIBLE_TAGS = 3
export function TagList({ tags }: { tags: string[] }) { /* … */ }
```

```ts
// features/invoices/constants.ts — used across the feature
export const INVOICE_STATUSES = ['draft', 'sent', 'paid', 'void'] as const
export type InvoiceStatus = (typeof INVOICE_STATUSES)[number]
```

```ts
// config/env.ts — parsed once, the only place reading process.env on the client side
import { z } from 'zod'
export const env = z.object({ NEXT_PUBLIC_API_URL: z.string().url() }).parse({
  NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_API_URL,
})
```

Repeated markup (nav items, filter options) → a config array next to the component, rendered by a map.

## 7. API DTO vs UI type

```ts
// features/users/api/user-api.ts
type UserDTO = { id: string; first_name: string; last_name: string; avatar_url: string | null }

export async function fetchUser(id: string): Promise<User> {
  const dto = await apiClient.get<UserDTO>(`/users/${id}`)
  return { id: dto.id, fullName: `${dto.first_name} ${dto.last_name}`, avatarUrl: dto.avatar_url }
}

// features/users/types.ts
export type User = { id: string; fullName: string; avatarUrl: string | null }
```

Backend renames stay inside `api/`.

## 8. Thin Server Action + service (Next.js)

```ts
// features/posts/server/posts.service.ts
import 'server-only'
import { db } from '@/lib/db'

export async function publishPost(userId: string, postId: string) {
  const post = await db.post.findUnique({ where: { id: postId } })
  if (!post || post.authorId !== userId) throw new Error('Forbidden')
  if (!canPublish(post)) throw new Error('Post is not ready') // domain rule
  await db.post.update({ where: { id: postId }, data: { publishedAt: new Date() } })
}
```

```ts
// features/posts/actions.ts
'use server'
import { revalidatePath } from 'next/cache'
import { verifySession } from '@/lib/auth'
import { publishPost } from './server/posts.service'
import { postIdSchema } from './schemas'

export async function publishPostAction(postId: string) {
  const { userId } = await verifySession()
  await publishPost(userId, postIdSchema.parse(postId))
  revalidatePath('/posts')
  return { ok: true }
}
```

## 9. Client wrapper around server content (Next.js)

```tsx
// features/cart/components/cart-drawer.tsx
'use client'
import { useState } from 'react'

export function CartDrawer({ children }: { children: React.ReactNode }) {
  const [open, setOpen] = useState(false)
  return (
    <>
      <button onClick={() => setOpen(true)}>Cart</button>
      {open && <aside>{children}</aside>}
    </>
  )
}
```

```tsx
// app/(shop)/layout.tsx — server
import { CartDrawer } from '@/features/cart/components/cart-drawer'
import { CartItems } from '@/features/cart/components/cart-items' // Server Component, reads DAL

export default function ShopLayout({ children }: LayoutProps<'/'>) {
  return (
    <>
      <CartDrawer><CartItems /></CartDrawer>
      {children}
    </>
  )
}
```

Only the toggle ships to the client; `CartItems` stays on the server.
