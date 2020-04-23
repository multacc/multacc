import * as admin from "firebase-admin";

export interface MultaccContact {
  multaccItems: Array<MultaccItem>;
  displayName: string;
  avatar?: string | undefined | null; // base64-encoded Dart Uint8List
  birthday: admin.firestore.Timestamp | undefined;

  // Don't care about these but they get produced by the multacc app
  clientKey?: any;
  serverKey?: any;
}

export interface MultaccItem {
  _t: string; // type
  _id: string; // id
  [field: string]: any;
}