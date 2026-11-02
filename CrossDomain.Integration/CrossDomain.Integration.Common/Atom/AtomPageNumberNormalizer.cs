namespace SFA.FCT.CrossDomain.Integration.Common.Atom
{
    public static class AtomPageNumberNormalizer
    {
        public static int FromUrlPageNumber(int urlPageNumber)
        {
            return urlPageNumber - 1;
        }

        public static int ToUrlPageNumber(int pageNumber)
        {
            return pageNumber + 1;
        }
    }
}
