import Control.Monad.Trans.Class
import Control.Monad.Trans.Cont

main = flip runContT return $ do
    lift $ putStrLn "alpha"
    callCC $ \k -> do
      k ()
      lift $ putStrLn "uh oh..."
    lift $ putStrLn "beta"          -- k
    lift $ putStrLn "gamma"         -- j
