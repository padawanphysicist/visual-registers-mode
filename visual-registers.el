;;; visual-registers.el --- Visualize registers through fringe line

;; This file is not part of GNU Emacs.

;; Copyright (C) 2021 Victor Santos

;; Author: Victor Santos <victor_santos@fisica.ufc.br>
;; Version: 1.0
;; Package-Requires: ((fringe-helper "0.1.1"))
;; URL: https://github.com/padawanphysicist/visual-registers

;;; Commentary:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'fringe-helper)
(require 'evil-fringe-mark-overlays)

(defvar vr/register-alist '()
  "Alist containing all overlays created by `point-to-register' from the session.")

(defun alist-set (key value alist)
  "Change value of KEY in ALIST to a new VALUE."
  (setq vr/register-alist (map-insert alist key value)))

(defun vr/char-to-fringe-symbol (char)
  "Return the fringe symbol bitmap corresponding to CHAR."
  (cdr (assoc char evil-fringe-mark-bitmaps)))

(defun vr/delete-register (register)
  "Delete REGISTER and remove its corresponding overlay in the fringe area."
  (interactive
   (list
    (read-key "(vr) Delete register: ")))
  (unless (equal nil (get-register register))
    (set-register register nil)
    (fringe-helper-remove (alist-get register vr/register-alist))
    (alist-set register nil vr/register-alist)))

(defun vr/point-to-register (register)
  "Create REGISTER and add its corresponding overlay in the fringe area."
  (interactive
   (list
    (read-key "(vr) Point to register: ")))
  (vr/delete-register register)
  (let ((fringe-overlay (fringe-helper-insert (vr/char-to-fringe-symbol register) (point))))
    (point-to-register register)
    (alist-set register fringe-overlay vr/register-alist)))

(defun vr/reset-registers ()
  "Delete all registers and their corresponding overlays in the fringe area."
  (interactive)
  (dolist (el register-alist)
    (vr/delete-register (car el))))

(defvar visual-registers-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-x r SPC") 'vr/point-to-register)
    map))

(define-minor-mode visual-registers-mode
  "Visualize your registers in the fringe."
  :lighter "VReg")

(provide 'visual-registers-mode)
;;; visual-registers.el ends here
