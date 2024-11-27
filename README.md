## Transform Symbol At Point

Easily change the symbol at point between camelcasing, snakecasing, dasherized and more.

Bind `transform-symbol-at-point` to the keybinding of your preference, for example:

``` emacs-lisp
(global-set-key (kbd "s-;") 'transform-symbol-at-point)
```

This will present a [`transient`](https://github.com/magit/transient) menu of the available
commands, which are 1 keypress away.

If you would prefer to use `which-key` instead of the default `transient` support, make sure
`which-key` is installed and bind `transform-symbol-at-point-map` instead:

``` emacs-lisp
(global-set-key (kbd "s-;") 'transform-symbol-at-point-map)
```

Each of the transformation commands can be called interactively as well:

* `transform-symbol-at-point-lower-camel-case`
* `transform-symbol-at-point-upper-camel-case`
* `transform-symbol-at-point-snake-case`
* `transform-symbol-at-point-dashed-words`
* `transform-symbol-at-point-downcase`
* `transform-symbol-at-point-capitalized-words`
* `transform-symbol-at-point-titleized-words`
* `transform-symbol-at-point-upcase`

To customize where the cursor ends up after transformation, set
`transform-symbol-at-point-cursor-after-transform` to one of the following:

* `symbol-end` (default)
* `symbol-start`
* `next-symbol`

Example installation with `use-package`:

``` emacs-lisp
(use-package transform-symbol-at-point
  :vc
  (:url "https://github.com/waymondo/transform-symbol-at-point")
  :custom
  (transform-symbol-at-point-cursor-after-transform 'next-symbol)
  :bind
  ("s-;" . transform-symbol-at-point))
```
