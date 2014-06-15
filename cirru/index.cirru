
doctype

html
  head
    title Todolist
    meta (:charset utf-8)
    link (:rel stylesheet) (:href css/style.css)
    link (:rel icon) (:href png/do.png)
    @if (@ inDev) $ @block
      link (:rel stylesheet) (:href css/dev.css)
      script (:src bower_components/react/react.js)
      script (:src bower_components/marked/lib/marked.js)
    @if (@ inBuild) $ @block
      link (:rel stylesheet) (:href css/build.css)
      script (:src //cdn.staticfile.org/react/0.10.0/react.min.js)
      script (:src //cdnjs.cloudflare.com/ajax/libs/marked/0.3.2/marked.min.js)
    script (:defer) (:src build/main.js)

  body