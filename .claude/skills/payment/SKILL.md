---
name: payment
description: "Stripe payment integration. Trigger khi cần checkout, subscription, billing, webhook thanh toán."
---

# Payment (Stripe)

```bash
npm install stripe @stripe/stripe-js
```

## One-time Checkout
```ts
// app/api/checkout/route.ts
import Stripe from 'stripe'
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!)

export async function POST(req: Request) {
  const { priceId, userId } = await req.json()
  const session = await stripe.checkout.sessions.create({
    mode: 'payment',
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${process.env.NEXT_PUBLIC_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${process.env.NEXT_PUBLIC_URL}/pricing`,
    metadata: { userId },
  })
  return Response.json({ url: session.url })
}
```

## Subscription
```ts
const session = await stripe.checkout.sessions.create({
  mode: 'subscription',            // thay 'payment'
  customer_email: user.email,
  line_items: [{ price: priceId, quantity: 1 }],
  // ...
})
```

## Webhook (quan trọng nhất)
```ts
// app/api/webhooks/stripe/route.ts
import { headers } from 'next/headers'

export async function POST(req: Request) {
  const body = await req.text()
  const sig = (await headers()).get('stripe-signature')!
  let event: Stripe.Event

  try {
    event = stripe.webhooks.constructEvent(body, sig, process.env.STRIPE_WEBHOOK_SECRET!)
  } catch {
    return new Response('Invalid signature', { status: 400 })
  }

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object
      await activateSubscription(session.metadata!.userId, session.subscription as string)
      break
    }
    case 'customer.subscription.deleted': {
      await cancelSubscription(event.data.object.metadata.userId)
      break
    }
  }
  return new Response('ok')
}
```

## Test locally
```bash
stripe login
stripe listen --forward-to localhost:3000/api/webhooks/stripe
```

## Env vars cần có
```
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
```

## Rules
- KHÔNG xử lý payment logic dựa trên client callback — luôn verify qua webhook
- Test với Stripe test cards: `4242 4242 4242 4242`
- Idempotency: check `event.id` trước khi process (tránh double-process)
