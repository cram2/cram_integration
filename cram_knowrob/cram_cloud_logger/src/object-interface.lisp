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

(defmethod cram-manipulation-interfaces:get-action-gripping-effort :around (object-type)
    (if *is-logging-enabled*
      (let ((reasoning-id (log-reasoning-task  "GetActionGrippingEffort")))
        (ccl::start-situation reasoning-id)
        (let ((query-result (call-next-method)))
          (ccl::stop-situation reasoning-id)
          (ccl::send-comment reasoning-id (concatenate 'string "INPUT -####- " (write-to-string object-type)))
          (ccl::send-comment reasoning-id (concatenate 'string "OUTPUT -####- " (write-to-string query-result)))
          query-result))        
      (call-next-method)))

(defmethod cram-manipulation-interfaces:get-action-gripper-opening :around (object-type)
  (if *is-logging-enabled*
      (let ((reasoning-id (log-reasoning-task  "GetActionGripperOpening")))
        (ccl::start-situation reasoning-id)
        (let ((query-result (call-next-method)))
          (ccl::stop-situation reasoning-id)
          (ccl::send-comment reasoning-id (concatenate 'string "INPUT -####- " (write-to-string object-type)))
          (ccl::send-comment reasoning-id (concatenate 'string "OUTPUT -####- " (write-to-string query-result)))
          query-result))        
      (call-next-method)))


(defmethod cram-manipulation-interfaces:get-action-grasps :around  (object-type arm object-transform-in-base)
  (if *is-logging-enabled*
      (let ((reasoning-id (log-reasoning-task  "GetActionGrasps")))
        (ccl::start-situation reasoning-id)
        (let ((query-result (call-next-method)))
          (ccl::stop-situation reasoning-id)
          query-result))        
      (call-next-method)))

(defmethod cram-manipulation-interfaces:get-container-closing-distance :around (container-name)
    (if *is-logging-enabled*
      (let ((reasoning-id (log-reasoning-task  "GetContainerClosingDistance")))
        (ccl::start-situation reasoning-id)
        (let ((query-result (call-next-method)))
          (ccl::stop-situation reasoning-id)
          (ccl::send-comment reasoning-id (concatenate 'string "INPUT -####- " (write-to-string container-name)))
          (ccl::send-comment reasoning-id (concatenate 'string "OUTPUT -####- " (write-to-string query-result)))
          query-result))        
      (call-next-method)))

(defmethod cram-manipulation-interfaces:get-container-opening-distance :around (container-name)
  (if *is-logging-enabled*
      (let ((reasoning-id (log-reasoning-task  "GetContainerOpeningDistance")))
        (ccl::start-situation reasoning-id)
        (let ((query-result (call-next-method)))
          (ccl::stop-situation reasoning-id)
          (ccl::send-comment reasoning-id (concatenate 'string "INPUT -####- " (write-to-string container-name)))
          (ccl::send-comment reasoning-id (concatenate 'string "OUTPUT -####- " (write-to-string query-result)))
          query-result))        
      (call-next-method)))

;;(defmethod cram-manipulation-interfaces:get-action-grasps :around  (object-type arm object-transform-in-base)
;;    (if *is-logging-enabled*
;;        (let* ((query-result (call-next-method))
;;               (query-id (log-reasoning-task "cram-manipulation-interfaces:get-action-grasps" (write-to-string object-type) (write-to-string query-result)))
;;               (pose-id (send-create-transform-pose-stamped object-transform-in-base)))
;;          (send-rdf-query query-id
;;                          "knowrob:parameter2"
;;                          (convert-to-prolog-str pose-id))
;;          query-result)
;;        (call-next-method)))

(defmethod cram-manipulation-interfaces:get-action-trajectory :around  (action-type arm grasp location objects-acted-on &key &allow-other-keys)
    (if *is-logging-enabled*
      (let ((reasoning-id (log-reasoning-task  "GetActionTrajectory")))
        (ccl::start-situation reasoning-id)
        (let ((query-result (call-next-method)))
          (ccl::stop-situation reasoning-id)
          (ccl::send-comment reasoning-id (concatenate 'string "INPUT -####- " (write-to-string action-type)
                                                       " -####- " (write-to-string arm)
                                                       " -####- " (write-to-string grasp)
                                                        " -####- " (write-to-string objects-acted-on)))
          (ccl::send-comment reasoning-id (concatenate 'string "OUTPUT -####- " (write-to-string query-result)))
          query-result))
      (call-next-method)))

(defmethod cram-manipulation-interfaces:get-location-poses :around (location-designator)
  (if *is-logging-enabled*
      (let ((reasoning-id (log-reasoning-task "GetLocationPoses")))
        (ccl::start-situation reasoning-id)
        (let ((query-result (call-next-method)))
          (ccl::stop-situation reasoning-id)
          (ccl::send-comment reasoning-id (concatenate 'string "INPUT -####- " (write-to-string location-designator)))
          (ccl::send-comment reasoning-id (concatenate 'string "OUTPUT -####- " (write-to-string query-result)))
          query-result))        
      (call-next-method)))

(defun log-reasoning-task (predicate-name)
  (let ((reasoning-url (create-reasoning-url predicate-name)))
      (attach-event-to-situation reasoning-url (get-parent-uri))))


(defun create-reasoning-url (predicate-name)
  (concatenate 'string "'http://www.ease-crc.org/ont/SOMA.owl#" predicate-name "'"))

;;(defun log-reasoning-task (predicate-name parameter reasoning-result)
;;  (let
;;      ((query-id (convert-to-prolog-str (get-value-of-json-prolog-dict
;;                      (cdaar
;;                       (send-cram-start-action
;;                        (concatenate 'string "knowrob:" (convert-to-prolog-str "ReasoningTask"))
;;                        " \\'TableSetting\\'"
;;                        (convert-to-prolog-str (get-timestamp-for-logging))
;;                        "PV"
;;                        "ActionInst"))
;;                      "ActionInst"))))
;;    (print "REASONING LOGGING")
;;    ;;(send-init-reasoning-query query-id)
;;    (send-predicate-query query-id predicate-name)
;;        (print "REASONING LOGGING 1")
;;    (send-parameter-query query-id parameter)
;;        (print "REASONING LOGGING 2")
;;    (send-link-reasoing-to-action query-id)
;;        (print "REASONING LOGGING 3")
;;    (send-result-query query-id reasoning-result)
;;       (print "REASONING LOGGING 4")
;;    query-id))


(defun send-init-reasoning-query (query-id)
  (send-prolog-query-1
   (create-query
    "cram_start_action"
    (list (concatenate 'string "knowrob:" (convert-to-prolog-str "PrologQuery"))
          "\\'TableSetting\\'"
          (get-timestamp-for-logging)
          "PV"
          query-id))))

(defun send-predicate-query (query-id predicate-name)
  (send-rdf-query query-id
                  "knowrob:predicate"
                  (convert-to-prolog-str predicate-name)))

(defun send-result-query (query-id result-query)
  (send-rdf-query query-id
                    "knowrob:result"
                    (convert-to-prolog-str result-query)))

(defun send-parameter-query (query-id parameter)
  (send-rdf-query query-id
                  "knowrob:parameter"
                  (convert-to-prolog-str parameter)))

(defun send-link-reasoing-to-action (query-id)
  (send-rdf-query (convert-to-prolog-str (car *action-parents*))
                  "knowrob:reasoningTask"
                  query-id))

(defun create-reasoning-task-query-id ()
  (convert-to-prolog-str (concatenate 'string "http://knowrob.org/kb/knowrob.owl#" "PrologQuery_" (format nil "~x" (random (expt 16 8))))))
  ;;(concatenate (concatenate 'string "knowrob:" (convert-to-prolog-str (concatenate 'string "PrologQuery_" (format nil "~x" (random (expt 16 8))))))))
