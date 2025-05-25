// import { createConsumer } from 'actioncable'
import { createConsumer } from '@rails/actioncable'

export function createChatConsumer() {
  // return createConsumer("ws://localhost:3000/cable");
  const token = localStorage.getItem('token')
  if (!token) {
    console.error('No JWT Token found.')
    return null
  }

  const cableUrl = `${import.meta.env.VITE_CABLE_URL || 'ws://localhost:3000/cable'}`;
  // const cableUrl = `ws://localhost:3000/cable?token=${token}`;
  const consumer = createConsumer(`${cableUrl}?token=${token}`);
  // console.log('asds', cableUrl)
  return consumer;
  // return `${cableUrl}?token=${token}`;
  // return createConsumer('ws://localhost:3000/cable', {
  //   Authorization: `Bearer ${token}`,
  // })
}
//   return createConsumer(cableUrl, { Authorization: `Bearer ${token}` });
// }
