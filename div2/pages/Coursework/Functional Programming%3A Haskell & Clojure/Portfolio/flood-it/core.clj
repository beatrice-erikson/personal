(def cursor-color "red")
(defn conv [pos]
  (+ (* (- (int (first pos)) 48) 10)(- (int (second pos)) 48)))

(defn color-recur [entity px py entities screen]
  (do
    (def up (filter #(= (+ (conv py) 1) (% :get-y))
                    (filter #(= (conv px) (% :get-x)) entities)))
    (def dn (filter #(= (- (conv py) 1) (% :get-y))
                    (filter #(= (conv px) (% :get-x)) entities)))
    (def lf (filter #(= (conv py) (% :get-y))
                    (filter #(= (- (conv px) 1) (% :get-x)) entities)))
    (def rt (filter #(= (conv py) (% :get-y))
                    (filter #(= (+ (conv px) 1) (% :get-x)) entities)))
    (prn up dn lf rt))
)

(defn name [x y]
  (if (< x 10)
    (if (< y 10)
      (str "0" x "0" y)
      (str "0" x y))
    (if (< y 10)
      (str x "0" y)
      (str x y))))

(defn make-cell [x y s ox oy c]
  (do (def lbl (name x y))
  (case c
    0 (assoc (check-box "@"
                 (style :check-box nil nil (bitmap-font) (color :red))
                 :set-name (str lbl "red"))
             :x (+ (* s x) ox) :y (+ (* s y) oy))
    1 (assoc (check-box "@"
                 (style :check-box nil nil (bitmap-font) (color :yellow))
                 :set-name (str lbl "yellow"))
             :x (+ (* s x) ox) :y (+ (* s y) oy))
    
    2 (assoc (check-box "@"
                 (style :check-box nil nil (bitmap-font) (color :green))
                 :set-name (str lbl "green"))
             :x (+ (* s x) ox) :y (+ (* s y) oy))
    3 (assoc (check-box "@"
                 (style :check-box nil nil (bitmap-font) (color :blue))
                 :set-name (str lbl "blue"))
             :x (+ (* s x) ox) :y (+ (* s y) oy))
    4 (assoc (check-box "@"
                 (style :check-box nil nil (bitmap-font) (color :white))
                 :set-name (str lbl "white"))
             :x (+ (* s x) ox) :y (+ (* s y) oy))
    nil)))

(defscreen main-screen
  :on-show
  (fn [screen entities]
    (update! screen :renderer (stage) :camera (orthographic))
    (def size 15)
    (def w 10)
    (def h 10)
    (def ox (/ (- (game :width) (* size w)) 2))
    (def oy (/ (- (game :height) (* size h)) 2))
    [(for [x (range w) y (range h)]
     (make-cell x y size ox oy (rand-int 5)))
     (for [x (range 5)]
       (case x
         0 (assoc (check-box "@" (style :check-box nil nil (bitmap-font) (color :red))
               :set-name (str (+ 50 x) (+ 50 h) "red"))
             :x (+ ox (* x size)) :y (+ oy size (* size h)))
         1 (assoc (check-box "@" (style :check-box nil nil (bitmap-font) (color :yellow))
               :set-name (str (+ 50 x) (+ 50 h) "yellow"))
             :x (+ ox (* x size)) :y (+ oy size (* size h)))
         2 (assoc (check-box "@" (style :check-box nil nil (bitmap-font) (color :green))
               :set-name (str (+ 50 x) (+ 50 h) "green"))
             :x (+ ox (* x size)) :y (+ oy size (* size h)))
         3 (assoc (check-box "@" (style :check-box nil nil (bitmap-font) (color :blue))
               :set-name (str (+ 50 x) (+ 50 h) "blue"))
             :x (+ ox (* x size)) :y (+ oy size (* size h)))
         4 (assoc (check-box "@" (style :check-box nil nil (bitmap-font) (color :white))
               :set-name (str (+ 50 x) (+ 50 h) "white"))
             :x (+ ox (* x size)) :y (+ oy size (* size h)))
              ))])
  
  :on-render
  (fn [screen entities]
    (clear!)
    (render! screen entities))
  
  :on-ui-changed
  (fn [screen entities]
    (def px [
      (first (actor! (:actor screen) :get-name))
      (second (actor! (:actor screen) :get-name))])
    (def py [
         (first (drop 2 (actor! (:actor screen) :get-name)))
         (second (drop 2 (actor! (:actor screen) :get-name)))])
    (def col (drop 4 (actor! (:actor screen) :get-name)))
    (prn (conv px) (conv py) col)
    (if (= (+ 50 h) (conv py))
      (case (conv px)
        50 (def cursor-color "red")
        51 (def cursor-color "yellow")
        52 (def cursor-color "green")
        53 (def cursor-color "blue")
        54 (def cursor-color "white"))
      (if (= cursor-color (apply str col))
        nil
        (if 
          (case cursor-color
            "red" (do (check-box! (:actor screen)
                                  :set-style (style :check-box nil nil (bitmap-font) (color :red)))
                    (check-box! (:actor screen)
                                :set-name (str (apply str px) (apply str py) "red")))
            "yellow" (do (check-box! (:actor screen)
                                     :set-style (style :check-box nil nil (bitmap-font) (color :yellow)))
                       (check-box! (:actor screen)
                                   :set-name (str (apply str px) (apply str py) "yellow")))
            "green" (do (check-box! (:actor screen)
                                    :set-style (style :check-box nil nil (bitmap-font) (color :green)))
                      (check-box! (:actor screen)
                                  :set-name (str (apply str px) (apply str py) "green")))
            "blue" (do (check-box! (:actor screen)
                                   :set-style (style :check-box nil nil (bitmap-font) (color :blue)))
                     (check-box! (:actor screen)
                                 :set-name (str (apply str px) (apply str py) "blue")))
            "white" (do (check-box! (:actor screen)
              :set-style (style :check-box nil nil (bitmap-font) (color :white)))
                      (check-box! (:actor screen)
              :set-name (str (apply str px) (apply str py) "white"))))
          nil
        )))
    nil)
  
  :on-resize
  (fn [screen entities]
    (height! screen (:height screen))))

(set-game-screen! main-screen)
