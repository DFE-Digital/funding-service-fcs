namespace SFA.FCT.ContractRequestDomain.NSBFramework
{
    public interface IValidator<T> where T : class
    {
        bool Validate(T message);
    }
}
