namespace SFA.FCT.CrossDomain.Integration.Common.Atom
{
    public interface IPageNumberMutator
    {
        int MutatePageNumberIn(int pageNumber);
        int MutatePageNumberOut(int pageNumber);
    }
}
