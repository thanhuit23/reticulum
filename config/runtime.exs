import Config

dev_janus_host = "143.198.201.239"

config :ret, RetWeb.Plugs.PostgrestProxy,
  hostname: System.get_env("POSTGREST_INTERNAL_HOSTNAME", "localhost")

case config_env() do
  :dev ->
    db_hostname = System.get_env("DB_HOST", "localhost")
    dialog_hostname = System.get_env("DIALOG_HOSTNAME", "dev-janus.reticulum.io")
    hubs_admin_internal_hostname = System.get_env("HUBS_ADMIN_INTERNAL_HOSTNAME", "143.198.201.239")
    hubs_client_internal_hostname = System.get_env("HUBS_CLIENT_INTERNAL_HOSTNAME", "143.198.201.239")
    spoke_internal_hostname = System.get_env("SPOKE_INTERNAL_HOSTNAME", "143.198.201.239")

    dialog_port =
      "DIALOG_PORT"
      |> System.get_env("443")
      |> String.to_integer()

    perms_key =
      "PERMS_KEY"
      |> System.get_env("")
      |> String.replace("\\n", "\n")

    # config :ret, Ret.JanusLoadStatus, default_janus_host: dialog_hostname, janus_port: dialog_port
    config :ret, Ret.JanusLoadStatus, default_janus_host: dev_janus_host, janus_port: 4443


    config :ret, Ret.Locking,
      session_lock_db: [
        database: "ret_dev",
        hostname: db_hostname,
        password: "postgres",
        username: "postgres"
      ]

    config :ret, Ret.PermsToken, perms_key: "\n-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANnLJyQytv0d10f9\nzogGK4yOLotDnlqq5BT7brtzThJjW20WLgzEs/ZnqWp17x9Vf7upUTXNVYeqEypE\nlNQ51fh7aIHnLpPVB8T4OdOGEgjzpy6umX8yj1x8QjiyjlwFviRADSObcjQHjP82\nMW/afuZpepw156RreLGS51d4o7HjAgMBAAECgYBGl3xWVUHOhO+UXAWnPSi8ZBFd\n/krDZISM8HoRs+voNeAaWYgPh2o1QaA963/YDiRatSSnZaiFUnDn0FbU+vIJAN0Z\nHJ3Km8wEp+k7EG8wmF+fH6KrTHdWy90ylsU7claVnHCtrlgiN/R1ZKcd+vP8FBJe\nt09cITDmn5cksmPKQQJBAPkcI8HgIjykgsWR1SKR0ZPAOP4giSbTy+QHYY0n0m8k\nJoNxuAqgkeWM0nc2YUNl5vYkvYuEMil97sFA28t6lFECQQDf0UXmv2y7O798s91l\nO7PfdCNftIhvV+5dnGeYzwvY3F84yIQKzq+a/ZRaLMxgvtC85Jlx8Bhey2aFm4lr\nvRnzAkAi/CS5cbTdN212OcjpFfmM+o4GgqNAZLZZy/+TR2hyW21dQHdMZsiWqHRW\ncbivMnyBTR+hnGs/EISbd3Rm20xBAkEAsae3SHVhpSzDzgQnFBfTqubQvULbmSW+\nuudPA+g0iypBGx1uUfXFRc1KWFl+0LwljAoYEmx1q6jf8+WFqtMrKQJBAI/5pO6I\nmmoPt7zm/w5NRsbRulIa1CsoDUp0brpsfQyt16FjnpxNzwCI0Buvxxiw+tULpNX/\nW+mEf9b+h8Dg2GA=\n-----END PRIVATE KEY-----"

    config :ret, Ret.PageOriginWarmer,
      admin_page_origin: "https://#{hubs_admin_internal_hostname}:8989",
      hubs_page_origin: "https://#{hubs_client_internal_hostname}:8080",
      spoke_page_origin: "https://#{spoke_internal_hostname}:9090"

    config :ret, Ret.Repo, hostname: db_hostname

    config :ret, Ret.SessionLockRepo, hostname: db_hostname

  :test ->
    db_credentials = System.get_env("DB_CREDENTIALS", "admin")
    db_hostname = System.get_env("DB_HOST", "localhost")

    config :ret, Ret.Repo,
      hostname: db_hostname,
      password: db_credentials,
      username: db_credentials

    config :ret, Ret.SessionLockRepo,
      hostname: db_hostname,
      password: db_credentials,
      username: db_credentials

    config :ret, Ret.Locking,
      session_lock_db: [
        database: "ret_test",
        hostname: db_hostname,
        password: db_credentials,
        username: db_credentials
      ]

  _ ->
    :ok
end
