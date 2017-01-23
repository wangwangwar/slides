import Control.Monad.Trans.Class
import Control.Monad.Trans.Cont

main = flip runContT return $ do
    lift $ putStrLn "alpha"
    num <- callCC $ \k -> do
      if 42 == 7 * 6
          then k 42
          else lift $ putStrLn "uh oh..."
      return 43
    lift $ putStrLn "beta"          -- k
    lift $ putStrLn "gamma"         -- j
    lift $ print num                -- l
