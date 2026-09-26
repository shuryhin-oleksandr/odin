# frontend-ui-architecture — дослідницька добірка

Матеріали, зібрані для скіла про архітектуру та організацію коду у React / Next.js
(App Router). Фокус — **де що лежить і як розбито**, не продуктивність.
Кожен запис: суть + що звідти взяти + посилання. Позначка ✅ — сторінку
прочитано під час дослідження (2026-09-26), 🔎 — знайдено через пошук, вміст
перевірено лише з анотації.

Питання, на які відповідає добірка:
1. Де лежать компоненти і як їх розбивати?
2. Де лежать константи?
3. Що виносити в utils / helpers / lib?
4. Де живе бізнес-логіка (hooks, services, domain, DAL)?
5. Де живе стан і data fetching?
6. Як це лягає на Next.js App Router (server / client, `app/`, server actions)?
7. Як це примусово підтримувати (lint-правила меж)?

---

## 1. Офіційна документація

### React — Thinking in React ✅
https://react.dev/learn/thinking-in-react

- Розбиття на компоненти за **single responsibility**: «a component should
  ideally only be concerned with one thing. If it ends up growing, it should
  be decomposed into smaller subcomponents».
- Ієрархія компонентів часто повторює форму моделі даних.
- Стан — мінімальний (DRY). Не стан: те, що не змінюється; те, що прийшло
  пропсом; те, що можна обчислити.
- Де живе стан: знайти всіх споживачів → найближчий спільний батько → там.

### React — Reusing Logic with Custom Hooks ✅
https://react.dev/learn/reusing-logic-with-custom-hooks

- Префікс `use` — тільки якщо функція викликає інші хуки. Інакше — звичайна
  функція (`getSorted`, а не `useSorted`) → це і є межа між **hook** і **util**.
- Хуки називати за конкретним use case (`useChatRoom`, `useOnlineStatus`), а
  не lifecycle-обгортки (`useMount`, `useEffectOnce` — 🔴).
- «Some duplication is fine» — не виносити хук заради кожного повтору.
- Хуки шарять **логіку зі станом**, а не **сам стан**; для спільного стану —
  lift up / context.

### React — You Might Not Need an Effect ✅
https://react.dev/learn/you-might-not-need-an-effect

- Похідні значення обчислювати під час рендера, не тримати у state.
- Логіка, спричинена подією, — в обробнику події, а не в `useEffect`.
- Скидання стану — через `key`, не через effect.
- Для фетчингу — бібліотека або фреймворк, а не ручні effects.

### React (legacy) — File Structure FAQ ✅
https://legacy.reactjs.org/docs/faq-structure.html

- React не має офіційної позиції. Два популярні підходи: **by feature/route**
  та **by file type**.
- Не більше 3–4 рівнів вкладеності.
- «Don't spend more than five minutes on choosing a file structure» — почати
  просто, реорганізувати, коли структура почне муляти.

### Next.js — Project structure and organization ✅
https://nextjs.org/docs/app/getting-started/project-structure

- Next.js **unopinionated**: «choose a strategy that works for you and your
  team and be consistent».
- Файли можна безпечно колокувати в `app/` — маршрутом стає тільки `page` /
  `route`.
- **Private folders** `_components`, `_lib` — виключені з роутингу; відділяють
  UI-логіку від роутингу.
- **Route groups** `(marketing)`, `(shop)` — групування без впливу на URL,
  окремі layouts.
- Три стратегії: (a) код поза `app/` (app — лише роутинг); (b) спільні папки
  всередині `app/`; (c) спільне в корені, специфічне — у сегментах маршрутів.
- Опційна папка `src/` відділяє код від конфігів.

### Next.js — Server and Client Components ✅
https://nextjs.org/docs/app/getting-started/server-and-client-components

- За замовчуванням `page`/`layout` — Server Components. Client — лише для
  стану, обробників, effects, browser API, custom hooks.
- `'use client'` — межа модульного графа; ставити на **листові** інтерактивні
  компоненти, а не на цілі сторінки.
- Server Components передаються в Client через `children` / props (slot).
- Context providers — окремий client-компонент, рендерити якомога глибше.
- `import 'server-only'` / `'client-only'` — захист від «environment
  poisoning».

### Next.js — How to think about data security (Data Access Layer) ✅
https://nextjs.org/docs/app/guides/data-security

- Для нових проєктів рекомендовано **Data Access Layer (DAL)**: тільки
  сервер, перевіряє авторизацію, повертає мінімальні **DTO**.
- Лише DAL читає `process.env` і ходить у БД.
- Обрати **один** підхід до фетчингу (HTTP API / DAL / component-level) і не
  змішувати.
- Server Actions — **тонкі**: делегують у `server-only` DAL, повертають лише
  потрібне UI; auth/authz перевіряти всередині кожної дії.
- Мутації — ніколи не side-effect рендера.

### Redux Style Guide ✅
https://redux.js.org/style-guide/

- «Feature folder» — рекомендований спосіб структури; логіка фічі — в
  одному slice-файлі.
- Максимум логіки в reducers (чисті, тестовані).
- Actions — як **події** (`orders/foodOrdered`), не сетери.
- Стор мінімальний, похідне — через selectors.
- Не все в глобальний стор: локальне — в компоненті; форми — локально.

---

## 2. Еталонні шаблони / архітектурні методології

### Bulletproof React (alan2207, ~30k⭐) ✅
https://github.com/alan2207/bulletproof-react/blob/master/docs/project-structure.md

- `src/`: `app` (routes, provider, router) · `assets` · `components` (shared)
  · `config` · `features` · `hooks` · `lib` (преконфігуровані бібліотеки) ·
  `stores` · `testing` · `types` · `utils`.
- Фіча: `api` · `components` · `hooks` · `stores` · `types` · `utils` (лише
  потрібні папки).
- **Без імпортів між фічами** — компонувати на рівні `app`.
- **Однонаправлений потік**: shared → features → app.
- Уникати barrel-файлів (tree-shaking у Vite).
- Enforce через ESLint `import/no-restricted-paths`.

### Feature-Sliced Design (FSD) ✅
https://feature-sliced.design/docs/get-started/overview

- Шари: `app → pages → widgets → features → entities → shared`; імпорт
  **лише вниз**.
- Slices — бізнес-домени всередині шару; slices одного шару не імпортують
  одне одного.
- Segments: `ui` · `api` · `model` (бізнес-логіка, стор, схеми) · `lib` ·
  `config` (константи, feature flags).
- Публічний API слайсу — `index.ts`.

### FSD + Next.js ✅
https://feature-sliced.design/docs/guides/tech/with-nextjs

- `app/` Next.js — у корені, FSD — у `src/`; шари FSD перейменувати на
  `_app`, `_pages`.
- `app/example/page.tsx` лише реекспортує: `export { ExamplePage as default,
  metadata } from '@/_pages/example'`.
- Окремий `index.server.ts` для server-only коду слайсу.
- БД-запити — сегмент `db` у `shared`.

### Martin Fowler / Juntao Qiu — Modularizing React Applications ✅
https://martinfowler.com/articles/modularizing-react-apps.html

- «React is a humble library for building views» — він не визначає
  архітектуру застосунку.
- Шари: **View** (JSX) → **Hooks / presentation state** → **Domain models**
  (чисті класи/функції бізнес-правил) → **Network / data**.
- Strategy pattern замість розкиданих `if (country === ...)` — проти
  «shotgun surgery».

### Khalil Stemmler — Client-Side Architecture ✅
https://khalilstemmler.com/articles/client-side-architecture/introduction/

- Шари: presentation · UI logic · interaction/model (бізнес-логіка) ·
  infrastructure (API).
- Бізнес-логіка фронтенду має жити окремо від фреймворку view.

### MakerKit — Next.js App Router project structure ✅
https://makerkit.dev/blog/tutorials/nextjs-app-router-project-structure

- Колокація в маршруті: `_components/`, `_lib/`.
- У `_lib/`: `*.loader.ts` (server fetch + `cache()`), `*.actions.ts`
  (тонкі), `*.service.ts` (бізнес-логіка, тестована), `*.schema.ts` (Zod,
  спільна для action і service).
- «Keep Server Actions thin: validate → call service → revalidate».

### vercel/next-learn (офіційний курс) 🔎
https://github.com/vercel/next-learn

- Дашборд курсу: `app/lib` (data, definitions, utils) + `app/ui`
  (компоненти за розділами). Приклад стратегії «спільні папки в `app/`».

### Vercel agent-skills (31k⭐) ✅
https://github.com/vercel-labs/agent-skills

- `react-best-practices` — **performance**, поза нашим фокусом (не
  дублювати).
- `composition-patterns` — compound components, уникати boolean-prop
  proliferation — релевантно для розбиття компонентів.

### shadcn/ui ✅
https://ui.shadcn.com/docs

- Компоненти як **власний код** у `components/ui` — базовий UI-шар, який
  редагується напряму, composable API.

### eslint-plugin-boundaries (~1k⭐) ✅
https://github.com/javierbrea/eslint-plugin-boundaries

- Декларативні правила залежностей між елементами (`app`, `features/*`,
  `shared`). Альтернатива — `import/no-restricted-paths` з
  eslint-plugin-import; для FSD — `steiger`.

---

## 3. Авторитетні практики (блоги)

### Kent C. Dodds — Colocation ✅
https://kentcdodds.com/blog/colocation

- «Place code as close to where it's relevant as possible».
- Тести, стилі, стан, **утиліти** — поруч із кодом, що їх використовує;
  центральний `utils/` породжує мертвий код.

### Kent C. Dodds — State Colocation ✅
https://kentcdodds.com/blog/state-colocation-will-make-your-react-app-faster

- Flowchart: `useState` → лише тут? лишити → потрібен дитині? опустити →
  потрібен сусідам? підняти → prop drilling? composition або context.

### Kent C. Dodds — Application State Management with React ✅
https://kentcdodds.com/blog/application-state-management-with-react

- Розрізняти **server cache** і **UI state** — «we make a mistake when we
  combine the two». Server cache — react-query/SWR.
- Ієрархія: local → lift → context → бібліотека.

### Kent C. Dodds — When to break up a component ✅
https://kentcdodds.com/blog/when-to-break-up-a-component-into-multiple-components

- Розбивати, коли є реальна проблема (reuse, стан заплутався, тестування,
  конфлікти в git, продуктивність). «NOT BEFORE».

### Kent C. Dodds — AHA Programming 🔎
https://kentcdodds.com/blog/aha-programming

- Avoid Hasty Abstractions: абстрагувати, коли дублювання стало реальним
  бар'єром і зрозуміло, якою має бути абстракція.

### Sandi Metz — The Wrong Abstraction ✅
https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction

- «Duplication is far cheaper than the wrong abstraction».
- Ліки: заінлайнити, спростити кожного споживача, видалити абстракцію.

### Dan Abramov — Presentational and Container Components (оновлення 2019) 🔎
https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0

- Сам автор: «I don't suggest splitting your components like this anymore» —
  хуки дають те саме розділення без штучного поділу. Не робити папки
  `containers/` vs `components/`.

### Dan Abramov — The Two Reacts ✅
https://overreacted.io/the-two-reacts/

- `UI = f(data)` (сервер, близько до даних) vs `UI = f(state)` (клієнт,
  миттєва інтерактивність) — ментальна модель розподілу server/client.

### Robin Wieruch — React Folder Structure ✅
https://www.robinwieruch.de/react-folder-structure/

- Еволюція в 5 кроків: один файл → кілька файлів → папки компонентів →
  технічні папки (`hooks/`, `context/`, `utils/`, `lib/`) → feature-папки.
- «Only reusable hooks end up in hooks/» — хук одного компонента лишається в
  його файлі.
- kebab-case для файлів; код тече shared → features → pages; фічі не
  імпортують одна одну.

### Josh W. Comeau — Delightful React File Structure ✅
https://www.joshwcomeau.com/react/file-structure/

- Протилежна думка: **by function, not by feature** — фічі розмиваються з
  розвитком продукту.
- **utils** = генеричні, переносні між проєктами; **helpers** =
  специфічні для проєкту.
- `constants.ts` — глобальні значення; компонент-специфічні константи та
  хелпери — в папці компонента.
- `index.ts` для реекспорту компонента — прийнятний.

### Alex Kondov — Tao of React ✅
https://alexkondov.com/tao-of-react/

- Модулі за фічами/маршрутами + `common/`.
- Складну розмітку з циклами/умовами — в окремий компонент; без вкладених
  render-функцій.
- Хелпери, що не потребують замикання на компонент, — **поза** компонентом.
- Повторювану розмітку (навігація, фільтри) — з конфігураційного об'єкта.

### TkDodo — Practical React Query ✅ / The Query Options API ✅ / Effective React Query Keys 🔎
- https://tkdodo.eu/blog/practical-react-query
- https://tkdodo.eu/blog/the-query-options-api
- https://tkdodo.eu/blog/effective-react-query-keys
- Не копіювати дані з `useQuery` у локальний state.
- Query key / queryOptions **factory на фічу**, колокована з фічею.

### TkDodo — Please Stop Using Barrel Files ✅
https://tkdodo.eu/blog/please-stop-using-barrel-files

- Barrels у застосунку → циклічні імпорти, 11k → 3.5k модулів у dev після
  видалення, не дають реальної інкапсуляції. Barrel доречний лише для
  **бібліотеки** / публічного API пакета.

### patterns.dev (Lydia Hallie, Addy Osmani) 🔎
- https://www.patterns.dev/react/hooks-pattern/
- https://www.patterns.dev/react/compound-pattern/
- https://www.patterns.dev/react/presentational-container-pattern/
- Hooks замість container/presentational; compound components для
  пов'язаних частин UI.

### Airbnb React/JSX Style Guide (148k⭐) ✅
https://github.com/airbnb/javascript/tree/master/react

- Один компонент на файл (кілька дрібних pure — ок); PascalCase для
  компонентів.

---

## 4. Спільнота (Habr, dev.to, Medium)

### Habr — «Архітектура фронтенд-застосунків на React. (Нам не потрібен FSD)» — Doubletapp ✅
https://habr.com/ru/companies/doubletapp/articles/870236/

- Контраргумент до FSD: високий поріг входу, мислення сутностями.
- Своя ієрархія: Pages → Widgets → Dummies (презентаційні) → UI; імпорт
  лише вниз.
- Бізнес-логіка — у хуку поруч із компонентом (`useMyComponent.ts`); API —
  `Api/` за сутностями; DTO-типи окремо від клієнтських моделей.

### Habr — інші статті про архітектуру фронтенду 🔎
- https://habr.com/ru/articles/726354/ — огляд модульної архітектури
- https://habr.com/ru/articles/770560/ — DDD на фронтенді
- https://habr.com/ru/articles/870710/ — Clean Architecture фронтенду, ч.2

### Критика FSD 🔎
- https://dev.to/arjunsanthosh/mastering-feature-sliced-design-lessons-from-real-projects-2ida
  — «slice everything» стає некерованим; починати просто і нарізати, коли
  з'являється потреба.
- https://dev.to/skorphil/feature-sliced-design-vs-clean-architecture-3m5k
  — нечіткі межі feature / entity / widget.

### Next.js-структури з практики 🔎
- https://dev.to/krunal_groovy/the-nextjs-15-app-router-project-structure-that-scales-with-examples-47ha
  — «No business logic in app/»; компонент, потрібний двом фічам,
  «graduates» у `/components`.
- https://blog.webdevsimplified.com/2022-07/react-folder-structure/
  — від простого до feature-based; `services/` для API; utils — лише чисті
  функції.

---

## 5. Книги (канон)

- Martin Fowler — *Refactoring* (2nd ed.) — Extract Function, Move Function,
  shotgun surgery → основа «куди перенести код».
- Robert C. Martin — *Clean Architecture* — dependency rule (залежності
  всередину, до домену) → однонаправлені імпорти shared ← features ← app.
- John Ousterhout — *A Philosophy of Software Design* — deep modules:
  маленький публічний інтерфейс, багато прихованої реалізації → публічний
  API фічі.
- Lydia Hallie, Addy Osmani — *Learning Patterns* (patterns.dev).

---

## 6. Суперечності

| Питання | Позиція A | Позиція B |
|---|---|---|
| Групування | **by feature** — Bulletproof, Redux, Wieruch, FSD, Kondov | **by function/type** — Josh Comeau (фічі «пливуть») |
| Barrel `index.ts` | потрібен як публічний API фічі/слайсу — FSD, Wieruch | шкодить, імпортуйте напряму — TkDodo, Bulletproof |
| Рівень формалізму | FSD: 6 шарів + лінтер | «Нам не потрібен FSD» / React FAQ «5 хвилин» / AHA |
| `app/` у Next.js | колокувати в маршрутах (`_components`, `_lib`) — Next docs, MakerKit | `app/` лише роутинг, код у `src/features` — FSD, dev.to |
| Container / Presentational | розділяти (patterns.dev, Habr «Dummies») | не треба, є хуки — Dan Abramov 2019 |
| Utils | центральна `utils/` — Bulletproof, webdevsimplified | колокувати, центральний utils гниє — Kent C. Dodds |
| Бізнес-логіка | у хуках поруч із компонентом — Habr Doubletapp | у чистих domain-функціях/класах поза React — Fowler, Stemmler, MakerKit services |

---

## 7. Складні кейси і як їх розв'язувати

### 7.1 Компонент потрібен двом фічам
- Bulletproof / FSD: фічі не імпортують одна одну. Або **підняти** в shared
  (`components/` / `entities`), або **скомпонувати** на рівні `app`/page
  через `children`/slots.

```tsx
// app/(shop)/product/[id]/page.tsx — композиція на рівні маршруту
import { ProductDetails } from '@/features/products/components/product-details'
import { AddToCartButton } from '@/features/cart/components/add-to-cart-button'

export default async function ProductPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  return <ProductDetails id={id} actions={<AddToCartButton productId={id} />} />
}
```

### 7.2 Де бізнес-логіка: хук чи чиста функція?
- Правило react.dev: якщо не викликає хуки — це не хук. Бізнес-правила —
  чисті функції (домен), хук лише зв'язує їх зі станом React.

```ts
// features/cart/domain/pricing.ts — чиста бізнес-логіка, без React
export function calculateTotal(items: CartItem[], discount: Discount | null) {
  const subtotal = items.reduce((sum, i) => sum + i.price * i.qty, 0)
  return discount ? applyDiscount(subtotal, discount) : subtotal
}

// features/cart/hooks/use-cart-total.ts — тонкий клей зі станом
export function useCartTotal() {
  const { data: items = [] } = useQuery(cartQueries.items())
  const discount = useDiscount()
  return calculateTotal(items, discount)
}
```

### 7.3 Server Action обростає логікою
- Next docs + MakerKit: action = validate → DAL/service → revalidate.

```ts
// features/posts/server/posts.service.ts
import 'server-only'
export async function publishPost(userId: string, input: PublishInput) {
  const post = await db.post.findUnique({ where: { id: input.postId } })
  if (post?.authorId !== userId) throw new Error('Forbidden')
  return db.post.update({ where: { id: post.id }, data: { publishedAt: new Date() } })
}

// app/posts/[id]/actions.ts
'use server'
export async function publishPostAction(formData: FormData) {
  const session = await auth()
  if (!session) throw new Error('Unauthorized')
  const input = publishSchema.parse(Object.fromEntries(formData))
  await publishPost(session.user.id, input)
  revalidatePath('/posts')
  return { ok: true }
}
```

### 7.4 Константи
- Константа одного компонента — у файлі компонента (над компонентом).
- Константи фічі — `features/<f>/constants.ts` (FSD: сегмент `config`).
- Глобальні (breakpoints, routes, ліміти) — `src/config/` або
  `constants.ts`; env — лише через `config/env.ts` (на сервері — лише DAL).
- Уникати одного гігантського `constants.ts` на весь проєкт.

### 7.5 utils vs helpers vs lib
- `utils/` — чисті, генеричні, без доменних знань (`formatDate`, `clamp`).
- доменні хелпери — у фічі (`features/orders/utils/…`), не в глобальному
  utils.
- `lib/` — преконфігуровані зовнішні бібліотеки (`lib/api-client.ts`,
  `lib/query-client.ts`, `lib/db.ts`).
- Мігрувати в shared лише на **другому** реальному використанні (AHA).

### 7.6 `'use client'` розповзається по дереву
- Ставити на листові інтерактивні компоненти; серверний контент передавати
  через `children`.

### 7.7 Дані з сервера копіюються в state
- Server cache — у react-query/SWR або в Server Components; у `useState` —
  лише UI state (відкрита модалка, чернетка форми).

---

## 8. Рекомендація (одна практика для скіла)

**Feature-based структура з однонаправленими залежностями
(Bulletproof React як база) + колокація + тонкий `app/`**:

```
src/
  app/                    # Next.js: лише роутинг, layouts, композиція фіч
    (group)/route/
      page.tsx            # тонкий: викликає loader фічі, рендерить компоненти
      _components/        # UI, потрібний лише цьому маршруту
  features/
    <feature>/
      components/         # UI фічі (server за замовчуванням, 'use client' на листях)
      hooks/              # хуки фічі
      api/ або queries.ts # queryOptions factory / fetchers
      server/             # server-only: DAL, services, actions
      domain/             # чисті бізнес-правила й типи
      constants.ts
      utils.ts
  components/ui/          # базовий дизайн-система UI (shadcn-подібний)
  components/             # спільні складені компоненти
  hooks/  lib/  utils/  config/  types/   # тільки справді спільне
```

Правила:
1. shared → features → app; фічі не імпортують одна одну (ESLint
   boundaries).
2. Колокація за замовчуванням; в shared — лише при другому використанні.
3. Бізнес-правила — чисті функції поза React; хуки й actions — тонкий клей.
4. Server cache ≠ UI state.
5. Без barrel-файлів у коді застосунку; імпорт напряму.
6. Жодних `containers/` vs `components/`; розбивати компонент, коли є
   реальна проблема.

FSD — розглядати для великих команд / довгоживучих продуктів, де потрібен
формальний лінтер шарів; для решти — надмірний.

---

## 9. Next.js App Router: архітектура (поглиблено)

Лише архітектура та організація коду. Кешування, streaming і продуктивність
свідомо не беремо, крім випадків, де вони визначають, **куди класти код**.
Базові Next.js-джерела (project structure, Server/Client Components, Data
Security) описані в розділі 1.

### 9.1 Джерела

#### Next.js: The Server and Client Boundary ✅
https://nextjs.org/docs/app/guides/server-and-client-boundary

- Два модульні графи: server і client. **Код** перетинає межу через
  імпорти, **дані** — через props (лише серіалізовані).
- `'use client'` ставиться лише на **вході** в клієнтське піддерево, а не на
  кожен файл.
- Спільний компонент не чіпати: зробити client-обгортку з директивою ближче
  до коду застосунку.
- Server Component вкладається в Client через `children` / slot-props:
  «owner» (хто пише JSX) визначає, де рендериться компонент, а не «parent».
- **Compound components (`Menu.Item`) не працюють через межу**: для
  використання з Server Component експортувати частини як named exports.
- Функції-пропси з Server у Client не можна, крім Server Actions. TS-плагін
  дозволяє function-prop, якщо назва `action` або закінчується на `Action`,
  тобто це **конвенція іменування**.
- Інтерактивність без client-компонента: `<details>`, `<form action>`.

#### Next.js: Fetching Data ✅
https://nextjs.org/docs/app/getting-started/fetching-data

- Фетчити в Server Component, **у тому компоненті, якому потрібні дані**:
  однакові `fetch` мемоізуються, тож prop drilling не потрібен.
- Для ORM/БД: обгорнути функцію в `React.cache` і викликати з кількох
  компонентів.
- Server → Client: передати **promise** без `await` і прочитати через `use()`
  у client-компоненті під `<Suspense>`.
- Клієнтський фетчинг (SWR / React Query) — лише коли дані залежать від
  клієнтського стану або браузерних API.
- «Keep the preload function next to the component that consumes the data»:
  ще один аргумент за колокацію.

#### Next.js: Server Actions and Mutations ✅
https://nextjs.org/docs/app/guides/server-actions

- Server Action — це **публічний POST-ендпоінт**. У кожній дії:
  authenticate + authorize, validate, обмежити return value.
- Приймати **ID + зміну**, а не цілий об'єкт; власника й решту даних читати з
  довіреного джерела. Zod перевіряє лише форму, а не право доступу.
- Дії виконуються **послідовно** на клієнті, тому **не використовувати їх для
  читання даних**.
- Приклад розміщення: `app/posts/actions.ts` з `'use server'` на рівні файлу.

#### Next.js: Backend for Frontend ✅
https://nextjs.org/docs/app/guides/backend-for-frontend

- Route Handlers (`route.ts`) — **публічні** HTTP-ендпоінти для
  webhooks, callback URL, не-HTML контенту, зовнішніх клієнтів, проксі.
- «Fetch data in Server Components directly from its source, not via Route
  Handlers», тобто не викликати свій `/api` із Server Component.
- Server Actions призначені для мутацій, не для читання.
- `proxy.ts` (раніше `middleware.ts`) — один на проєкт, лише для
  оптимістичних перевірок і редиректів.
- «Next.js backend capabilities are not a full backend replacement».

#### Next.js: Forms ✅
https://nextjs.org/docs/app/guides/forms

- Форма → Server Action; валідація на сервері через Zod/Valibot;
  `useActionState` для помилок і pending; `useFormStatus` для кнопки;
  `useOptimistic`.
- Додаткові аргументи передавати через `action.bind(null, id)`.
- Форма з помилками валідації — client-компонент; сама дія — в
  `actions.ts`.

#### Next.js: Authentication ✅
https://nextjs.org/docs/app/guides/authentication

- **DAL з `verifySession()`** (`import 'server-only'` + `cache`), який
  викликають у data-функціях, actions і route handlers.
- **Не робити auth-перевірки в layouts**: layout не перерендерюється при
  навігації і не блокує рендер вкладених сегментів. Перевіряти близько до
  даних (у DAL) або в компоненті, що рендериться умовно.
- `return null` у layout для неавторизованих **не рекомендовано**, бо в
  застосунку кілька точок входу.
- `proxy.ts` виконує лише оптимістичні перевірки за cookie, без БД. «Should
  not be your only line of defense».
- Client Components не можуть імпортувати DAL: дані передаються з
  серверного батька через props або context.
- Схеми та типи (`SignupFormSchema`, `FormState`) лежать в окремому
  `lib/definitions.ts`, спільному для action і форми.

#### Sebastian Markbåge (React core): How to Think About Security in Next.js (23.10.2023) ✅
https://nextjs.org/blog/security-nextjs-server-components-actions

- Три моделі роботи з даними: **HTTP APIs** (існуючі великі проєкти, Zero
  Trust), **Data Access Layer** (нові проєкти), **component-level** (лише
  прототипи). «Stick to one approach… exceptions pop out as suspicious».
- DAL — внутрішня бібліотека, яка перевіряє доступ перед поверненням даних і
  віддає **DTO**. Лише DAL читає `process.env`.
- «A Client Component should not accept more data than the minimal data it
  needs»: вузькі типи props у `'use client'` файлах.
- `params` / `searchParams` — ворожий ввід; access control перечитувати при
  кожному читанні, не передавати його через props.
- Рендер не робить мутацій; мутації йдуть через Server Actions.
- `route.ts` і middleware — «escape hatches», їх треба окремо аудитувати.

#### Next.js: Layouts and Pages ✅
https://nextjs.org/docs/app/getting-started/layouts-and-pages

- Layout зберігає стан і не перерендерюється під час навігації, тому він
  підходить для «оболонки», але не для логіки, прив'язаної до запиту.
- `searchParams` prop використовувати, коли параметри впливають на
  **завантаження даних**; `useSearchParams` — коли тільки на клієнтську
  фільтрацію.
- `PageProps<'/route'>`, `LayoutProps<'/route'>` — згенеровані типи замість
  ручних.

#### TkDodo: You Might Not Need React Query ✅
https://tkdodo.eu/blog/you-might-not-need-react-query

- З RSC-фреймворком фетчинг за замовчуванням іде через сервер. React Query
  лишається для infinite scroll, polling, offline і для гібриду «prefetch на
  сервері → `useQuery` на клієнті».

#### TanStack Query: Advanced SSR (Next.js App Router) 🔎
https://tanstack.com/query/latest/docs/framework/react/guides/advanced-ssr

- Патерн prefetch у Server Component → `HydrationBoundary` → `useQuery` у
  client. QueryClient provider — окремий `'use client'` файл.

#### Next.js: Project structure (повторно, розділ 1) ✅
https://nextjs.org/docs/app/getting-started/project-structure

- `_folder` — приватні папки, `(group)` — групи маршрутів,
  `@slot` / `(.)intercept` — паралельні й перехоплювані маршрути (модалки),
  `src/`.

### 9.2 Правила для Next.js (витяг для скіла)

1. **`app/` = роутинг + композиція.** `page.tsx` / `layout.tsx` тонкі:
   прочитати `params`, викликати функцію даних фічі, скомпонувати компоненти.
   Бізнес-логіки в `app/` немає.
2. **Server Component за замовчуванням.** `'use client'` ставити лише на
   листових інтерактивних компонентах. Серверний вміст передавати в
   клієнтські обгортки через `children`.
3. **Один підхід до даних на проєкт**: DAL для нових, HTTP API для існуючого
   бекенду. Не змішувати.
4. **DAL / server-код фічі** позначений `import 'server-only'`, повертає DTO,
   сам перевіряє сесію й права. `process.env` і БД доступні **лише** тут.
5. **Server Actions тонкі**: `'use server'` файл → auth → validate (схема) →
   виклик DAL/service → `revalidatePath`/`updateTag` → мінімальний результат.
   Приймати ID, а не об'єкти. Іменувати `somethingAction`.
6. **Читання — у Server Components**, мутації — через Server Actions,
   **Route Handlers** — лише для публічних / зовнішніх ендпоінтів (webhooks,
   OAuth callback, файли, RSS). Свій `/api` із серверних компонентів не
   викликати.
7. **Auth — у DAL**, не в layout. `proxy.ts` лише для оптимістичних
   редиректів.
8. **Props на межі server → client вузькі**: тільки поля, потрібні
   компоненту, без `User`-цілком, токенів, приватних даних.
9. **Колокація в маршруті** через `_components/`, `_lib/` (специфічне для
   маршруту) **або** у `src/features/*` (спільне між маршрутами). Код, який
   використовують два маршрути, переїжджає у фічу або в shared.
10. **Route groups** `(marketing)`, `(app)`, `(auth)` групують за розділами
    та layout, а не за технічними типами.
11. **Схеми валідації** (Zod) лежать у фічі (`schemas.ts`) і спільні для
    action, service та форми.
12. **Providers** (theme, QueryClient) — окремий `'use client'` файл,
    підключений у layout якомога глибше.
13. **Compound components**, які використовуються з Server Components,
    експортувати named exports, а не `Menu.Item`.

### 9.3 Приклад структури Next.js + feature-based

```
src/
  app/
    (marketing)/
      page.tsx
    (app)/
      layout.tsx                 # оболонка, без auth-логіки
      invoices/
        page.tsx                 # тонкий: getInvoicesDTO() → <InvoiceTable/>
        [id]/
          page.tsx
          _components/           # UI лише цього маршруту
            invoice-header.tsx
        @modal/(.)[id]/page.tsx  # перехоплений маршрут-модалка
    api/
      webhooks/stripe/route.ts   # публічний ендпоінт
    providers.tsx                # 'use client'
  features/
    invoices/
      components/
        invoice-table.tsx        # server
        invoice-form.tsx         # 'use client' + useActionState
      server/
        invoices.dal.ts          # 'server-only', verifySession, DTO
        invoices.service.ts      # 'server-only', бізнес-правила з I/O
      actions.ts                 # 'use server', тонкі
      domain/
        invoice-status.ts        # чисті функції, без React і без I/O
      schemas.ts                 # Zod, спільні для action/form
      constants.ts
  lib/
    db.ts                        # 'server-only'
    auth.ts                      # verifySession (DAL-ядро)
  components/ui/                 # дизайн-система
proxy.ts                         # лише оптимістичні редиректи
```

```tsx
// src/app/(app)/invoices/page.tsx — тонка сторінка
import { getInvoicesDTO } from '@/features/invoices/server/invoices.dal'
import { InvoiceTable } from '@/features/invoices/components/invoice-table'

export default async function InvoicesPage(props: PageProps<'/invoices'>) {
  const { status } = await props.searchParams
  const invoices = await getInvoicesDTO({ status })
  return <InvoiceTable invoices={invoices} />
}
```

```ts
// src/features/invoices/server/invoices.dal.ts
import 'server-only'
import { cache } from 'react'
import { verifySession } from '@/lib/auth'
import { db } from '@/lib/db'

export const getInvoicesDTO = cache(async (filter: { status?: string }) => {
  const { userId } = await verifySession()
  const rows = await db.invoice.findMany({ where: { ownerId: userId, ...filter } })
  return rows.map(({ id, number, amount, status }) => ({ id, number, amount, status }))
})
```

```ts
// src/features/invoices/actions.ts
'use server'
import { revalidatePath } from 'next/cache'
import { verifySession } from '@/lib/auth'
import { markInvoicePaid } from './server/invoices.service'
import { markPaidSchema } from './schemas'

export async function markInvoicePaidAction(invoiceId: string) {
  const { userId } = await verifySession()
  const { id } = markPaidSchema.parse({ id: invoiceId })
  await markInvoicePaid(userId, id) // перевірка власника всередині service
  revalidatePath('/invoices')
  return { ok: true }
}
```

### 9.4 Суперечності, специфічні для Next.js

| Питання | Позиція A | Позиція B |
|---|---|---|
| Де код маршруту | колокувати в `app/**/_components`, `_lib` (Next docs, MakerKit) | `app/` лише роутинг + реекспорт, усе в `src/` (FSD, dev.to) |
| Де фетчити | компонент, якому потрібні дані (Next docs: memoized fetch) | сторінка викликає loader і передає вниз (DAL-first, «тонкі сторінки») |
| React Query у App Router | переважно не потрібен (TkDodo, Next docs) | потрібен для polling / infinite / offline, гібрид prefetch + hydrate |
| Server Actions | inline в компоненті (closures, шифрування) | окремий `actions.ts` файл, тонкий, делегує в DAL |
| Auth | `proxy.ts` / middleware централізовано | DAL біля даних; proxy лише оптимістичний (Next docs, Markbåge) |

### 9.5 Складні кейси Next.js

- **Потрібен стан у layout, який обгортає серверні сторінки** → client
  provider з `children`; layout лишається серверним.
- **Клієнтська форма потребує даних користувача** → серверний батько
  викликає DAL і передає вузький DTO props-ами.
- **Той самий запит потрібен у layout і page** → функція DAL з `cache()`
  викликається в обох місцях, без prop drilling.
- **Модалка поверх списку зі своїм URL** → parallel `@modal` + intercepting
  `(.)[id]`, а не глобальний стан модалки.
- **Server-only і client-код в одній фічі** → розділити на
  `server/` (з `server-only`) і `components/`. У FSD для цього є окремий
  `index.server.ts`.
- **Зовнішній бекенд, не наша БД** → модель HTTP API: DAL стає тонким
  клієнтом до API (Zero Trust), решта правил та сама.
