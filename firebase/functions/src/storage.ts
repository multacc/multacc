import * as admin from "firebase-admin";
import {MultaccContact} from "./schema";

admin.initializeApp();
const db = admin.firestore();

/**
 * Store a shareable contact in the database
 * @param contact Contact to store
 * @return The firestore document id for contact document
 */
export async function storeContact(contact: MultaccContact): Promise<string> {
  // @todo Store items separately from contact when sharing
  // @body This will be useful when we have sharing templates, so multiple templates are automatically updated
  // @body when an item is changed.
  return db.collection('sharedContacts').add(contact).then((docRef) => docRef.id);
}

/**
 * Get a stored contact from the database
 * @param untrimmedId The firestore document id for contact document
 * @return Stored contact
 */
export async function getStoredContact(untrimmedId: string): Promise<MultaccContact | undefined> {
  const id = trimSlashes(untrimmedId);
  return db.collection('sharedContacts').doc(id).get().then(doc => {
    if (doc.data() === undefined) {
      return undefined;
    }
    const contact: MultaccContact = doc.data() as MultaccContact;
    // Store the server key in the contact
    contact.serverKey = id;
    // Destroy any client key that may be in the contact
    contact.clientKey = undefined;
    return contact;
  }).catch(err => {
    console.error(err);
    return undefined;
  });
}

export function trimSlashes(path: string): string {
  return path.replace(/^\/+|\/+$/g, '');
}