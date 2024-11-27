;;; transform-symbol-at-point.el --- Transforming your symbols at point  -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2024 Justin Talbott

;; Author: Justin Talbott
;; URL: https://github.com/waymondo/transform-symbol-at-point
;; Version: 0.1.0
;; Package-Requires: ((emacs "24") (s "1.12.0") (transient "0.3.7"))
;; License: GNU General Public License version 3, or (at your option) any later version
;; Keywords: convenience, tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Easily change the symbol at point between camelcasing, snakecasing, dasherized and more.

;; Bind `transform-symbol-at-point' to the keybinding of your preference, for example:

;; (global-set-key (kbd "s-;") 'transform-symbol-at-point)

;; If you would prefer to use `which-key' instead of the default `transient' support, make sure
;; `which-key' is installed and bind `transform-symbol-at-point-map' instead:

;; (global-set-key (kbd "s-;") 'transform-symbol-at-point-map)

;; Each of the transformation commands can be called interactively as well:

;; * `transform-symbol-at-point-lower-camel-case'
;; * `transform-symbol-at-point-upper-camel-case'
;; * `transform-symbol-at-point-snake-case'
;; * `transform-symbol-at-point-dashed-words'
;; * `transform-symbol-at-point-downcase'
;; * `transform-symbol-at-point-capitalized-words'
;; * `transform-symbol-at-point-titleized-words'
;; * `transform-symbol-at-point-upcase'

;; To customize where the cursor ends up after transformation,
;; set `transform-symbol-at-point-cursor-after-transform' to one of the following:

;; * `symbol-end' (default)
;; * `symbol-start'
;; * `next-symbol'

;;; Code:

(require 's)
(require 'transient)

(defgroup transform-symbol-at-point nil
  "Transforming the symbol at point customizations."
  :group 'convenience
  :prefix "transform-symbol-at-point-")

(defcustom transform-symbol-at-point-cursor-after-transform 'symbol-end
  "Determines where the cursor should be after a successful transformation."
  :type '(choice
          (const :tag "Symbol End" symbol-end)
          (const :tag "Symbol Start" symbol-start)
          (const :tag "Next Symbol" next-symbol)))

(defun transform-symbol-at-point--internal (fn)
  "Transform the symbol at point with `FN'."
  (let ((symbol (thing-at-point 'symbol t))
        (bounds (bounds-of-thing-at-point 'symbol)))
    (delete-region (car bounds) (cdr bounds))
    (insert (funcall fn symbol))
    (cond ((eq transform-symbol-at-point-cursor-after-transform 'symbol-start)
           (goto-char (car bounds)))
          ((eq transform-symbol-at-point-cursor-after-transform 'next-symbol)
           (forward-thing 'symbol)
           (beginning-of-thing 'symbol)))))

;;;###autoload
(defun transform-symbol-at-point-lower-camel-case ()
  "Transform symbol at point into lower camel case format."
  (interactive)
  (transform-symbol-at-point--internal #'s-lower-camel-case))

;;;###autoload
(defun transform-symbol-at-point-upper-camel-case ()
  "Transform symbol at point into upper camel case format."
  (interactive)
  (transform-symbol-at-point--internal #'s-upper-camel-case))

;;;###autoload
(defun transform-symbol-at-point-snake-case ()
  "Transform symbol at point into snake case format."
  (interactive)
  (transform-symbol-at-point--internal #'s-snake-case))

;;;###autoload
(defun transform-symbol-at-point-dashed-words ()
  "Transform symbol at point into dashed words format."
  (interactive)
  (transform-symbol-at-point--internal #'s-dashed-words))

;;;###autoload
(defun transform-symbol-at-point-downcase ()
  "Transform symbol at point into downcase format."
  (interactive)
  (transform-symbol-at-point--internal #'s-downcase))

;;;###autoload
(defun transform-symbol-at-point-capitalized-words ()
  "Transform symbol at point into capitalized words format."
  (interactive)
  (transform-symbol-at-point--internal #'s-capitalized-words))

;;;###autoload
(defun transform-symbol-at-point-titleized-words ()
  "Transform symbol at point into titleized words format."
  (interactive)
  (transform-symbol-at-point--internal #'s-titleized-words))

;;;###autoload
(defun transform-symbol-at-point-upcase ()
  "Transform symbol at point into upcase format."
  (interactive)
  (transform-symbol-at-point--internal #'s-upcase))

(defvar transform-symbol-at-point-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "c") 'transform-symbol-at-point-lower-camel-case)
    (define-key map (kbd "C") 'transform-symbol-at-point-upper-camel-case)
    (define-key map (kbd "_") 'transform-symbol-at-point-snake-case)
    (define-key map (kbd "-") 'transform-symbol-at-point-dashed-words)
    (define-key map (kbd "d") 'transform-symbol-at-point-downcase)
    (define-key map (kbd "u") 'transform-symbol-at-point-capitalized-words)
    (define-key map (kbd "t") 'transform-symbol-at-point-titleized-words)
    (define-key map (kbd "U") 'transform-symbol-at-point-upcase)
    map)
  "Keymap for `transform-symbol-at-point'.")

(fset 'transform-symbol-at-point-map transform-symbol-at-point-map)

(transient-define-prefix transform-symbol-at-point ()
  "Transient menu for transforming symbol at point."
  [
   "Transform String At Point"
   ("c" "lower camelcase" transform-symbol-at-point-lower-camel-case)
   ("C" "upper camelcase" transform-symbol-at-point-upper-camel-case)
   ("_" "snakecase" transform-symbol-at-point-snake-case)
   ("-" "dasherize" transform-symbol-at-point-dashed-words)
   ("d" "downcase" transform-symbol-at-point-downcase)
   ("u" "capitalize" transform-symbol-at-point-capitalized-words)
   ("t" "titleize" transform-symbol-at-point-titleized-words)
   ("U" "upcase" transform-symbol-at-point-upcase)])


(when (require 'which-key nil t)
  (which-key-add-keymap-based-replacements transform-symbol-at-point-map
    "c" '("lower camelcase" . transform-symbol-at-point-lower-camel-case)
    "C" '("upper camelcase" . transform-symbol-at-point-upper-camel-case)
    "_" '("snakecase" . transform-symbol-at-point-snake-case)
    "-" '("dasherize" . transform-symbol-at-point-dashed-words)
    "d" '("downcase" . transform-symbol-at-point-downcase)
    "u" '("capitalize" . transform-symbol-at-point-capitalized-words)
    "t" '("titleize" . transform-symbol-at-point-titleized-words)
    "U" '("upcase" . transform-symbol-at-point-upcase)))

(provide 'transform-symbol-at-point)
;;; transform-symbol-at-point.el ends here
