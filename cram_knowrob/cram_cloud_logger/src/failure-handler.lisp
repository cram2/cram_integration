(in-package :ccl)

(defmethod cpl:fail :around (&rest args)
  (if *is-logging-enabled*
      (progn
        (log-failure (car ccl::*action-parents*) (car args))
        (call-next-method))
      (call-next-method)))
