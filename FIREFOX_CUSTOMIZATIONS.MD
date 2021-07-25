# Firefox customization notes
## about:config

### make open in same tab for repeated launches

> browser.link.open_newwindow.restriction = 0

> browser.link.open_newwindow = 1

### enable custom window style
> toolkit.legacyUserProfileCustomizations.stylesheets = true

### add custom css
Go to profile directory

```shell
cd ${profile_dir}
mkdir chrome
touch userChrome.css
```

# the following content to userChrome.css
```css
#TabsToolbar
{
    visibility: collapse;
}

#back-button
{
    display: none;
}

#forward-button
{
    display: none;
}

#userContext-icons
{
    visibility: collapse;
}
```