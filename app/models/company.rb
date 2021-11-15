class Company < ApplicationRecord
    has_many :users

    # STATUS PENDENTES -> empty, completed STATUS NAO PENDENTES -> accepted, rejected  (subentendido)
    enum status: { empty: 0, completed: 10, accepted: 20, rejected: 30 }
end
