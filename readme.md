### Create new NodeJS Web App template

```
mkdir [projname]
cd [projname]
npm init
npm install --save botbuilder restify@5.0.0
```

### copy the following following files from 'Hello-ChatConnector' to [projname]
```
.gitignore
iisnode.yml
web.config
```

### add dev dependency to enable publish

```
cd [projname]
npm install --save-dev zip-folder request
```

### create your bot by adding code
...

### prepare to build template package
```
cd [projname]
rmdir /S /Q node_modules
del package-lock.json
```


