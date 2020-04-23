import {MultaccContact} from "./schema";

export function contactPage(contact: MultaccContact, key: string) {
  let html = `
  <!DOCTYPE html>
  <title>${contact.displayName} | Multacc</title>
  <link rel="stylesheet" href="/static/style.css">
  <ul>
  `;
  contact.multaccItems.forEach((item) => {
    html += '<li>';
    html += item._t;
    html += ' item id ';
    html += item._id;
  });
  return html + '</ul>';
}