import Hom.Animate
import Hom.MainLoop

main = do
  handle <- requestAnimationFrame $ putStrLn "hey"
  return ()