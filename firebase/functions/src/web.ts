import {MultaccContact} from "./schema";
import * as querystring from "querystring";

export function contactPage(contact: MultaccContact, key: string) {
  let html = `
  <!DOCTYPE html>
  <title>${title(contact, '|')}</title>
  <link rel="stylesheet" href="/static/style.css">
  <div class="deeplink"><a href="${generateDynamicLink(contact, key)}">Open in Multacc</a></div>
  <ul class="contacts">
  `;
  contact.multaccItems.forEach((item) => {
    html += '<li>';
    html += item._t;
    html += ' item id ';
    html += item._id;
  });
  return html + '</ul>';
}

function generateDynamicLink(contact: MultaccContact, key: string): string {
  return "https://multacc.page.link/?" + querystring.stringify({
    link: "https://multa.cc/" + key, // Should link to an expirable link instead of directly to contact when link expiration is added
    apn: "com.multacc",
    efr: "1",
    st: title(contact, 'at'),
    sd: "Contact information shared with Multacc",
    // TODO: si --> avatar
  });
}

function title(contact: MultaccContact, separator: string): string {
  return ((contact?.displayName ?? '').trim() !== '' ? `${contact.displayName} ${separator} ` : '') + 'Multacc';
}