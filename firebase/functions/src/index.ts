import * as functions from "firebase-functions";
import {CallableContext} from "firebase-functions/lib/providers/https";

export const sendContact = functions.https.onCall((data: any, context: CallableContext) => {
  const jsonContact: string = data;
  const uid: string | undefined = context.auth?.uid;
  console.log('Received contact: ' + jsonContact + ' from user ' + uid);
  return {
    url: 'https://multa.cc/whatever'
  };
});

export const receiveContact = functions.https.onCall((data: any, context: CallableContext) => {
  // const contactId: string = data.id; // "whatever" if we got here from multa.cc/whatever
  return {
    serverKey: null,
    multaccItems: null,
    displayName: null,
    avatar: null,
    birthday: null
  };
});