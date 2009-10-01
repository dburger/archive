// seending email appropriately read as html or plain text depending on the
// reader:
email = new MimeMessage(getMailSession());

BodyPart bpHtml = new MimeBodyPart();
bpHtml.setContent("<b>bold</b> html content", "text/html");

BodyPart bpText = new MimeBodyPart();
bpText.setContent("plain text!", "text/plain");

Multipart mp = new MimeMultipart("alternative");
mp.addBodyPart(bpHtml);
mp.addBodyPart(bpText);

email.setContent(mp);
