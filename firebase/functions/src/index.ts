import * as functions from "firebase-functions";
import {CallableContext} from "firebase-functions/lib/providers/https";
import {MultaccContact} from "./schema";
import {getStoredContact, storeContact} from "./storage";
import {contactPage} from "./web";

export const sendContact = functions.https.onCall((data: any, context: CallableContext) => {
  const contact: MultaccContact = data;

  // @todo Validate contact against interface
  // @body I assume it will be easier to validate with a cloud function than to use a firestore security rule
  // @body since we already have an interface in schema.ts and there exist methods to validate objects against TypeScript
  // @body interfaces at runtime, such as https://github.com/gristlabs/ts-interface-checker

  // @todo Associate stored contact with user
  // @body This will allow the contact to be updated/deleted in the future

  // @todo URL expiration for shared contacts
  // @body Customizable by the sharer


  const uid: string | undefined = context.auth?.uid;
  console.log("user " + uid + " uploaded a contact");

  // Store the contact in the database and return id
  return storeContact(contact);
});

export const receiveContact = functions.https.onCall((data: any, context: CallableContext) => getStoredContact(data));

// @todo Create cloud function to follow someone

export const displayContact = functions.https.onRequest(async (req, res) => {
  const key: string = req.path.replace(/^\/+|\/+$/g, '');
  const contact: MultaccContact | undefined = await getStoredContact(key);
  if (!contact) {
    res.status(404).send();
  } else {
    res.status(200).send(contactPage(contact, key));
  }
});