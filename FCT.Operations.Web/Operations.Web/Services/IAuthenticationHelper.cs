namespace Operations.Web.Services
{
    using Dtos;

    public interface IAuthenticationHelper
    {
        string GetAuthenticationResult(AuthenticationRequest request);
    }
}