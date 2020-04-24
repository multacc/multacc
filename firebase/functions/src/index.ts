import * as functions from "firebase-functions";
import {CallableContext} from "firebase-functions/lib/providers/https";
import {MultaccContact} from "./schema";
import {getStoredContact, storeContact, trimSlashes} from "./storage";
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

  // @todo Separate multa.cc links from stored contacts in backend
  // @body This will allow URL expiration, make link customization less dangerous, etc.
  // @body multa.cc links should automatically open the app if it is installed. This can be accomplished a couple ways;
  // @body we could use a Dynamic Link with the web link as the fallback url (we would still need to generate another
  // @body Dynamic Link on this page since we wouldn't want the first link to redirect users to Google Play, though we
  // @body may want to look into Google Play Instant), or we could use normal Android App Links or plain Deep Links to
  // @body make the app handle multa.cc links. The latter may be preferable because it allows us to manage the multa.cc
  // @body links directly in our database rather than through the Dynamic Links SDK, which might get a little messy
  // @body with link expiration. Reading list:
  // @body https://medium.com/flutter-community/deep-links-and-flutter-applications-how-to-handle-them-properly-8c9865af9283
  // @body https://developer.android.com/training/app-links/verify-site-associations
});

export const receiveContact = functions.https.onCall((data: any, context: CallableContext) => getStoredContact(data.id));

export const displayContact = functions.https.onRequest(async (req, res) => {
  const key: string = trimSlashes(req.path);
  const contact: MultaccContact | undefined = await getStoredContact(key);
  if (!contact) {
    res.status(404).send();
  } else {
    res.status(200).send(contactPage(contact, key));
  }
});