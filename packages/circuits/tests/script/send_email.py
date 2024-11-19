import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def send_html_email(
    sender_email, sender_password, recipient_email, subject, html_content
):
    # Create a multipart message
    msg = MIMEMultipart("alternative")
    msg["From"] = sender_email
    msg["To"] = recipient_email
    msg["Subject"] = subject

    # Attach the HTML body to the email
    msg.attach(MIMEText(html_content, "html"))

    try:
        # Connect to the Gmail SMTP server
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.starttls()  # Upgrade the connection to a secure encrypted SSL/TLS connection
        server.login(sender_email, sender_password)

        # Send the email
        server.sendmail(sender_email, recipient_email, msg.as_string())

        print("Email sent successfully!")
    except Exception as e:
        print(f"Failed to send email: {e}")
    finally:
        server.quit()


if __name__ == "__main__":
    # Replace with your details
    sender_email = "<YOUR_EMAIL_ADDRESS>"
    sender_password = "<YOUR_GMAIL_APP_PASSWORD>"
    recipient_email = "<RECIPIENT_EMAIL_ADDRESS>"
    subject = "ZK Email:"

    # Basic HTML content
    html_content = """
    <html>
    <body>
        <div dir="ltr">ZK Email Command</div>
    </body>
    </html>
    """

    # Send the email
    send_html_email(
        sender_email, sender_password, recipient_email, subject, html_content
    )
