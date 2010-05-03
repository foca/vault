Vault, a lightweight Object Document Mapper
===========================================

    class User
      include Vault

      key      :id
      property :name
      property :email
    end

    user = User.new(:id => 1, :name => "John", :email => "john@example.org")
    user.save

    User.find(1) #=> user
    User.all     #=> [user]
    User.size    #=> 1

Storage
-------

By default Vault stores everything in an in-memory hash. Each model (class in
    which you included the `Vault` module) has its own, independent storage.

To change the storage you can call `store_objects_in(store)` in the class
definition. A store is any object that implements this API:

* `Store#size` returns an integer with the total amount of elements in the store
* `Store#each(&block)` a store must implement `each` and include Enumerable
* `Store#[](key)` receiving the key it should return a hash of all attributes
**except for the key**.
* `Store#[]=(key, attributes)` attributes will be a hash with the attributes
**except** for the key.
* `Store#delete(key)` shall delete the item without the given key.

By default, a simple instance of Hash is a valid store. This library also
provides `Vault::Storage::YamlStore` that lets you serialize objects into YAML.
Each model will get its own YAML file.

TODO
----

* Relationships/Associations
* Scopes (probably just as a clean implementation of associations)

More docs?
----------

I will get to it eventually. For now, read the specs and the source—it is a
small library. Or help and write some docs :)

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don’t break it in a future version
  unintentionally.
* Commit, do not mess with Rakefile, version, or history. (if you want to have
  your own version, that is fine but bump version in a commit by itself I can
  ignore when I pull.)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright © 2010 [Nicolás Sanguinetti](http://github.com/foca), licensed under
an MIT license. See MIT-LICENSE for details.
