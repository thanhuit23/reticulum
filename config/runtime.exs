import Config

config :ret, RetWeb.Plugs.PostgrestProxy,
  hostname: System.get_env("POSTGREST_INTERNAL_HOSTNAME", "localhost")

dev_janus_host = "vpcdialog.teacherville.co.kr"

case config_env() do
  :dev ->
    db_hostname = System.get_env("DB_HOST", "localhost")
    dialog_hostname = System.get_env("DIALOG_HOSTNAME", "meta2.teacherville.co.kr")
    hubs_admin_internal_hostname = System.get_env("HUBS_ADMIN_INTERNAL_HOSTNAME", "meta2.teacherville.co.kr")
    hubs_client_internal_hostname = System.get_env("HUBS_CLIENT_INTERNAL_HOSTNAME", "meta2.teacherville.co.kr")
    spoke_internal_hostname = System.get_env("SPOKE_INTERNAL_HOSTNAME", "meta2.teacherville.co.kr")

    dialog_port =
      "DIALOG_PORT"
      |> System.get_env("443")
      |> String.to_integer()

    perms_key =
      "PERMS_KEY"
      |> System.get_env("")
      |> String.replace("\\n", "\n")

    config :ret, Ret.JanusLoadStatus, default_janus_host: dev_janus_host, janus_port: 4443

    config :ret, Ret.Locking,
      session_lock_db: [
        database: "ret_dev",
        hostname: db_hostname,
        password: "postgres",
        username: "postgres"
      ]

    config :ret, Ret.PermsToken, perms_key: "-----BEGIN PRIVATE KEY-----\nMIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAPYFrHZ1j5PsRbTL\nYfBV+qxa19MaQv7gQKlRsMGJvkTWxHlmb4xiIRa+kNr+BCqptuCc1K3hWqiQTFP/\n7a1fzlOtsf+SxfpWCQD5YpdBoSHzMiW9PbjS+E7cNg0FzRE9DMXyz1f7d1mVXVVi\nx/rnjWxG3V/YKF6SIK37C27f/Ka7AgMBAAECgYEAn9fH2Z9ADcew8mpB07jJCTps\nh0fEx3xEBr6ArP4llOxE8utPBlKrVO+zhdUMN/vUSdMbi22jTWmTbfAWKFLa5dUM\nBQRAxUmfHLECYFMjkLkw1nDtL0CGCbmvneuL0NpkwiTkpLfP1V3ByPrGiX8qSUlB\n4uEdxL/RKoRZlk8DSSECQQD+mcQ3SHQ/jfm/uJnLapoT5KPrzQoe1lHoppM5XGga\nMcL+UDbEQ6eh6Gr2ELPH3dgFTj3rExE80Apz6MZlN6nXAkEA91/WQR8+Nykam57f\nGl8Be5Y7qDLaDa7UJGVFvOTi6YmUMz9RhuupZ3MMKW4enYK/1dlrKS1pb9RQ9YTb\njkN1vQJBAIfrOQg2YvEG73y9pUUmPOk/147r4GpECmhEfTZTMbRCOpIf6ozufVB/\nTpLcqc2ajleOxJl5jWtEuT/V1gx1IfMCQQCFSa44CI2NSyh7EW9E1kwGOzyJtFyp\nYroLokWhMfLRwr+HnWZgPDpa8zJqYFs+o2SZ5TxIQ5+8EbpNj/h8/vxBAkASDGWz\n4Bzdz5/7+RYDyIcBAcIlB5KzxfxgJ0dODapNMIkFtHmCMd9pw+ytyWTTnpqLUpyx\nFnm9BUFMxDa2t2NJ\n-----END PRIVATE KEY-----"

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
