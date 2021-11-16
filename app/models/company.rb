class Company < ApplicationRecord
    has_many :users

    # STATUS PENDENTES -> incomplete, completed STATUS NAO PENDENTES -> accepted, rejected  (subentendido)
    enum status: { incomplete: 0, completed: 10, accepted: 20, rejected: 30 }

    has_one :owner, -> { where owner: true },
    class_name: 'User'
end
