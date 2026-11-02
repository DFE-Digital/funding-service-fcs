namespace Operations.Worker.Audit
{
    using System.Collections.Generic;
    using System.Linq;

    public static class ByteArrayExtensions
    {
        public static byte[] gzipHeaderBytes = { 0x1f, 0x8b, 8, 0, 0, 0, 0, 0, 4, 0 };
        public static byte[] gzipHeaderBytesAlt = { 0x1f, 0x8b, 8, 0, 0, 0, 0, 0, 0, 10 }; // GZipStream from .net core has a different header
        public static byte[] gzipBadFooter1 = {0, 0x9F, 1, 0};
        public static byte[] gzipBadFooter4 = { 32, 0x9F, 2, 3, 0 };
        public static byte[] gzipBadFooter5 = { 0x9F, 1, 0 };
        public static byte[] gzipGoodFooter = { 0, 0 };
        public static byte[] gzipGoodFooter2 = { 3, 0 };
        public static byte[] gzipGoodFooter3 = { 0 };
        public static byte[] gzipBadFooter2 = { 0, 0, 1};
        private static readonly List<byte[]> ListZipHeaders = new List<byte[]>
        {
            gzipHeaderBytes,
            gzipHeaderBytesAlt
        };

        public static List<(byte[] badFooter, byte[] goodFooter)> problemFooters =
            new List<(byte[] badFooter, byte[] goodFooter)>
            {
                (gzipBadFooter1, gzipGoodFooter),
                (gzipBadFooter2, gzipGoodFooter),
                (gzipBadFooter4, gzipGoodFooter2),
                (gzipBadFooter5, gzipGoodFooter3)
            };

        public static bool IsZipped(this byte[] data)
        {
            if (data != null && data.Length >= gzipHeaderBytes.Length)
            {
                var header = data.Take(gzipHeaderBytes.Length);
                return header.SequenceEqual(gzipHeaderBytes) || header.SequenceEqual(gzipHeaderBytesAlt);
            }

            return false;
        }

        public static byte[] RemoveHeaderIfZippedOrUnZipped(this byte[] bytes)
        {
            foreach (var zipHeader in ListZipHeaders)
            {
                var indexOf = FindSequence(bytes, zipHeader);
                if (indexOf != -1)
                {
                    var bytesWithoutHeader = bytes.Skip(indexOf).ToArray();

                    return bytesWithoutHeader.ReplaceFooterIfNotRight();
                }
            }

            // we are unzipped
            return bytes;
        }

        public static byte[] RemoveAnythingBeforeOrAfterTheCurlyBraces(this byte[] bytes)
        {
            const int curlyLeftBrace = 123;
            const int curlyRightBrace = 125;
            var indexOfCurlyLeftBrace = bytes.ToList().IndexOf(curlyLeftBrace);

            // remove everything before the left curly
            var bytesWithoutLeftCurly = bytes.Skip(indexOfCurlyLeftBrace).ToList();

            // remove everything after the right curly
            var indexOfRightCurly = bytesWithoutLeftCurly.LastIndexOf(curlyRightBrace);

            return bytesWithoutLeftCurly.Take(indexOfRightCurly + 1).ToArray();
        }

        private static byte[] ReplaceFooterIfNotRight(this byte[] bytes)
        {
            foreach (var problemFooter in problemFooters)
            {
                var badFooterLength = problemFooter.badFooter.Length;
                var footer = bytes.Skip(bytes.Length - badFooterLength).ToArray();
                if (footer.SequenceEqual(problemFooter.badFooter))
                {
                    bytes = bytes.Take(bytes.Length - badFooterLength).ToList().Concat(problemFooter.goodFooter)
                        .ToArray();

                    break;
                }
            }

            bytes = bytes.RemoveSequenceFromStartOfFooterIfPresent(new byte[] {0x9F, 2});
            bytes = bytes.RemoveSequenceFromStartOfFooterIfPresent(new byte[] {0x9F, 1});

            return bytes;
        }

        private static byte[] RemoveSequenceFromStartOfFooterIfPresent(this byte[] bytes, byte[] sequenceToRemove)
        {
            if (bytes.Length > 3)
            {
                var footer = bytes.Skip(bytes.Length - 4).ToArray();
                var firstTwoOfFooter = footer.Take(sequenceToRemove.Length).ToList();
                if (firstTwoOfFooter.SequenceEqual(sequenceToRemove))
                {
                    footer = footer.Skip(sequenceToRemove.Length).ToArray();
                    return bytes.Take(bytes.Length - 4).ToList().Concat(footer).ToArray();
                }
            }

            return bytes;
        }

        private static int FindSequence(byte[] array, byte[] sequence)
        {
            int end = array.Length - sequence.Length; // past here no match is possible
            byte firstByte = sequence[0];
            int start = 0;

            while (start <= end)
            {
                if (array[start] == firstByte)
                {
                    // scan for rest of sequence
                    for (int offset = 1; ; ++offset)
                    {
                        if (offset == sequence.Length)
                        { // full sequence matched
                            return start;
                        }
                        if (array[start + offset] != sequence[offset])
                        {
                            break;
                        }
                    }
                }
                ++start;
            }

            // end of array reached without match
            return -1;
        }
    }
}
