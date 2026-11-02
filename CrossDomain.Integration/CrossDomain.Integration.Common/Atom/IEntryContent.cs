namespace SFA.FCT.CrossDomain.Integration.Common.Atom
{
    public interface IEntryContent<in T>
    {
        void SetRootProperty(T value);
    }
}