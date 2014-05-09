yard profile -user depot1,depot2,depot3
yard profile -user -append depot4
yard profile -user -remove depot2
yard profile "foo" #named profile
yard profile "foo" depot1,depot2

yard sync # Sync user profile or default profile
yard sync +foo # Sync "foo" profile
yard sync depot1,depot2,depot3 # Sync just depot1, depot2 and depot3