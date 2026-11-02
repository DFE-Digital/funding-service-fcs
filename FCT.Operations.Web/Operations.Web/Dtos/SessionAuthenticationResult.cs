namespace Operations.Web.Dtos
{
    public class SessionAuthenticationResult
    {
        public SessionAuthenticationResult(string token)
        {
            Token = token;
        }

        public string Token { get; }
    }
}