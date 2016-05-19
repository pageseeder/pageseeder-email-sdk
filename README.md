# PageSeeder Email SDK

This is a simple framework to help developers create customized email templates for PageSeeder.

It is mainly used to accelerate the development and testing of email templates.

For more info on PageSeeder emails see [PageSeeder Email API](https://dev.pageseeder.com/guide/configuration/emails.html)

## Installation

This project includes the Gradle wrapper so as long as you have Java and an editor, 
you should be able to get started.

If using Eclipse, I recommend using [Buildship](http://projects.eclipse.org/projects/tools.buildship).

## Get started

First, you need to update the details of your PageSeeder installation 
in the `gradle.properties` file so that the generated emails use the correct 
email domain and URLs. 

```
  # Define the Email domain of your server
  emailDomain=pageseeder.localhost

  # Define the host URL of your PageSeeder server
  hostURL=https://pageseeder.localhost:8443/ps/

  # Define where PageSeeder is installed locally (Optional)
  localPageSeeder=C:/PageSeeder/default
  localProject=myproject
```

## Generate the emails

To generate all the emails, use the following command:

```sh
  $ gradlew run
```

To generate HTML emails as separate files, use the following command:

```sh
  $ gradlew generateHTMLEmails
```

The generated HTML emails will be saved as HTML documents in the `/email/html/` folder.

To generate text emails in separate files, use the following command:

```sh
  $ gradlew generateTextEmails
```

The generated plain text emails will be saved as txt files in `/email/text/`

To deploy on a local PageSeeder installation, use the following command:

```sh
  $ gradlew installOnLocalPageSeeder
```

## Customize the emails

The actual HTML email templates are in `/src/main/template/html/`.

When the SDK is used for the first time, the default templates located in
`/src/main/defaults/html/` are copied to `/src/main/template/html/`
which contains main files to modify are in `/src/main/template/html/`.

The XML generated by PageSeeder as a source for the email templates is stored in the
`/src/main/message/` folder and is used as a source for the templates. There is no reason 
to modify it and it should cover most use cases.

### `_custom.xsl`

This module defines the header and footer for all emails, logo/branding.
Any custom templates should be defined here are this makes it easier to upgrade templates in the future.

### `styles.css`

This stylesheet defines most of the styles used for emails.
It is useful to modify this stylesheet to change color scheme.

### Individual notification templates

Individual templates can be modified to change:
 - the wording
 - the links and button so that they point to the correct location


## Working with existing templates

If you already have templates that you want to update, you can also use the SDK.

1. Copy your files into the `src/main/template/html` folder. 
2. Edit the individual templates to ensure that they match `notification[@template = 'template_id']` 
   instead of just `notification`

## File organisation

The files are organized as follows:

```
/src
   /main
      /defaults   Default templates (copied to template/html the first time)
      /message    Source XML generated by PageSeeder
      /template   
         /html    XSLT templates for HTML emails
         /text    XSLT templates for text emails
      /xslt       XSLT used for the SDK (do not modify)
/email            Generated HTML for emails 
```

## Conventions

The XSLT modules starting with `_` (underscore) provide common reusable templates and function.
They should generally not be modified except for 


## Limitations

 - Requires PageSeeder 5.9 or later
 - In order for templates to be generated all notification templates must be qualified using the
   `@template` attribute

## Future development

 - Simplify CSS and remove most inline styles from existing code
 - Improve responsiveness
 - Generate `.eml` files so that generated HTML can be tested directly in Outlook
 - Improve inliner to take advantage of well tested frameworks (e.g. Foundation Ink)
 - Better handling of images (offline / online)
 - Install on remote servers
 - Automatically send test templates with PageSeeder 
 - Detect CSS properties which aren't supported by some clients (e.g. `padding` on `p` for Outlook)
