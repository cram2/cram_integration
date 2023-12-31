;;;
;;; Copyright (c) 2017-2022, Sebastian Koralewski <seba@cs.uni-bremen.de>
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions are met:
;;;
;;;     * Redistributions of source code must retain the above copyright
;;;       notice, this list of conditions and the following disclaimer.
;;;     * Redistributions in binary form must reproduce the above copyright
;;;       notice, this list of conditions and the following disclaimer in the
;;;       documentation and/or other materials provided with the distribution.
;;;     * Neither the name of the Institute for Artificial Intelligence/
;;;       Universitaet Bremen nor the names of its contributors may be used to
;;;       endorse or promote products derived from this software without
;;;       specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
;;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;; POSSIBILITY OF SUCH DAMAGE.

(in-package :ccl)

(defun get-url-variable-result-as-str-from-json-prolog-result (variable-name json-prolog-result)
  (let* ((variable-name-key
           (transform-variable-name-to-variable-key variable-name))
         (json-prolog-first-result
           (car json-prolog-result))
         (prolog-string-url
           (string (cdr (assoc variable-name-key json-prolog-first-result)))))
    prolog-string-url))

(defun transform-variable-name-to-variable-key (variable-name)
  (read-from-string (concatenate 'string "|?" variable-name "|")))

(defun convert-to-lisp-str (prolog-str)
  (subseq prolog-str 1 (- (length prolog-str) 1)))

(defun get-designator-property-value-str (designator property-keyname)
  (string (cadr (assoc property-keyname (desig:properties designator)))))

(defun get-property-value-str (properties property-keyname)
  (string (cadr (assoc property-keyname properties))))

(defun string-start-with (str prefix)
  (if (< (length str) (length prefix))
      nil
      (string= prefix (subseq str 0 (length prefix)))))

(defun get-timestamp-for-logging ()
  ;;(write-to-string (truncate (cram-utilities:current-timestamp))))
  (get-more-specific-timestamp-for-logging))

(defun get-more-specific-timestamp-for-logging ()
  ;;  (format nil "~d"  (truncate (* 1000000 (cram-utilities:current-timestamp)))))
  (format nil "~f"(cram-utilities:current-timestamp)))

(defun get-id-from-query-result (query-result)
  (let ((x (string (cdaar query-result))))
    (subseq x 2 (- (length x) 2))))

(defun get-value-of-json-prolog-dict (json-prolog-dict key-name)
  (let ((json-prolog-dict-str (string json-prolog-dict)))
    (let ((key-name-search-str (concatenate 'string key-name "\":\"")))
      (let ((key-name-pos (+ (search key-name-search-str (string json-prolog-dict-str)) (length key-name-search-str))))
        (let ((sub-value-str (subseq (string json-prolog-dict-str) key-name-pos)))
          (subseq  sub-value-str 0 (search "\"" sub-value-str)))))))

(defun create-owl-literal (literal-type literal-value)
  (concatenate 'string "literal(type(" literal-type "," literal-value "))"))

(defun convert-to-prolog-str(lisp-str)
  (when (symbolp lisp-str)
    (setf lisp-str (symbol-name lisp-str)))
  (if (eq 0 (search "'" lisp-str))
      (concatenate 'string "\\'" (subseq lisp-str 1 (- (length lisp-str) 1)) "\\'")
      (concatenate 'string "\\'" lisp-str "\\'")))

(defun create-float-owl-literal (value)
  (create-owl-literal "xsd:float" (format nil "~f" value)))

(defun create-string-owl-literal (value)
  (create-owl-literal "xsd:string" value))

(defun get-last-element-in-list (l)
  (if (or (eq (length l) 1) (eq (length l) 0))
      (car l)
      (get-last-element-in-list (cdr l))))


(defun create-parameters (parameter-list)
  (if (listp parameter-list)
      (let ((result (car parameter-list)))
        (dolist (item (cdr parameter-list))
          (setq result (concatenate 'string result "," item)))
        result)))

(defun create-query (query-name parameter-list)
  (concatenate 'string query-name "(" (create-parameters parameter-list) ")"))

(defun create-rdf-assert-query (a b c)
  (concatenate 'string "rdf_assert(" a "," b "," c ", \\'LoggingGraph\\')"))




