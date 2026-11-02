namespace SFA.FCT.ContractRequestDomain.NSBFramework
{
    public interface ITransform<T, TOUT>
        where T : class
        where TOUT : class
    {
        TOUT Transform(T message);
    }
}
