import { createConsumer } from 'actioncable'

export function createChatConsumer() {
  // return createConsumer("ws://localhost:3000/cable");
  const token = localStorage.getItem('token')
  if (!token) {
    console.log('No JWT Token found.')
    return null
  }

  const cableUrl = `${import.meta.env.VITE_CABLE_URL} || ws://localhost:3000/cable`;

  return createConsumer(cableUrl, {
    Authorization: `Bearer ${token}`,
  })
}

// const cableUrl = `ws://localhost:3000/cable?token=${token}`;
// const consumer = createConsumer(cableUrl);
// return consumer;
//   return createConsumer(cableUrl, { Authorization: `Bearer ${token}` });
// }
