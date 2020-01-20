class JsonWebToken
  class << self
    def encode(payload, exp = 2.hours.from_now)
      # Tiempo de expiracion (2 horas)
      payload[:exp] = exp.to_i

      # Codificado
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      # Decodificado
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body

        # Errores personalizados
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      raise ExceptionHandler::ExpiredSignature, e.message
    rescue JWT::DecodeError, JWT::VerificationError => e
      raise ExceptionHandler::DecodeError, e.message
    end
  end
end