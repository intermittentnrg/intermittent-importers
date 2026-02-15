require 'faraday'
require 'aws-sdk-lambda'
require 'base64'

class LambdaAdapter < Faraday::Adapter
  def initialize(app, function_name:, region: nil)
    super(app)
    @function_name = function_name
    @lambda_client = Aws::Lambda::Client.new(region: region)
  end

  def call(env)
    super
    request_body = build_request_body(env)

    response = @lambda_client.invoke(
      function_name: @function_name,
      payload: JSON.generate(request_body)
    )

    parse_response(env, response)
  end

  private

  def build_request_body(env)
    body = env[:body]
    body = body.read if body.respond_to?(:read)

    {
      method: env[:method].to_s.upcase,
      url: env[:url].to_s,
      headers: env[:request_headers] || {},
      body: body
    }
  end

  def parse_response(env, response)
    payload = JSON.parse(response.payload.string)

    status = payload['statusCode']
    response_headers = payload['headers'] || {}

    body = payload['body']
    body = Base64.decode64(body) if payload['isBase64Encoded']

    save_response(env, status, body, response_headers)
  end
end

Faraday::Adapter.register_middleware lambda_adapter: LambdaAdapter
