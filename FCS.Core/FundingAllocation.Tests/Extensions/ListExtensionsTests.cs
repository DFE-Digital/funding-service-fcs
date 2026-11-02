namespace FundingAllocation.Tests.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using FluentAssertions;
    using FundingAllocation.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class ListExtensionsTests
    {

        [TestMethod, TestCategory("UnitTest")]
        public void ListExtensions_GetBatchesOfSize_ShouldSplitListIntoChunks()
        {
            // Arrange
            const int numberOfChunks = 5;
            const int chunkSize = 20;

            var source = Enumerable.Range(0, numberOfChunks * chunkSize).ToList();

            // Act
            var chunks = source.GetBatchesOfSize(chunkSize).ToList();

            // Assert
            chunks.Count.Should().Be(numberOfChunks);

            foreach (var chunk in chunks)
            {
                chunk.Count.Should().Be(chunkSize);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ListExtensions_GetBatchesOfSize_ShouldSplitListIntoChunksWithUnevenSizes()
        {
            // Arrange
            const int numberOfChunks = 5;
            const int normalChunkSize = 20;
            const int lastChunkSize = 3;

            var source = Enumerable.Range(0, ((numberOfChunks - 1)* normalChunkSize) + lastChunkSize).ToList();

            // Act
            var chunks = source.GetBatchesOfSize(normalChunkSize).ToList();

            // Assert
            chunks.Count.Should().Be(numberOfChunks);
            chunks.Take(numberOfChunks -1).ToList().ForEach(chunk => chunk.Count.Should().Be(normalChunkSize));
            chunks.Last().Count.Should().Be(lastChunkSize);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ListExtensions_GetBatchesOfSize_ShouldGetEmptyListWhenSourceEmpty()
        {
            // Arrange
            var source = new List<int>();

            // Act
            var chunks = source.GetBatchesOfSize(33).ToList();

            // Assert
            chunks.Should().BeEmpty();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ListExtensions_GetBatchesOfSize_ShouldGetEmptyListWhenSourceNull()
        {
            // Act
            var chunks = ((List<int>) null).GetBatchesOfSize(33).ToList();

            // Assert
            chunks.Should().BeEmpty();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ListExtensions_GetBatchesOfSize_ShouldGetEmptyListWhenChunkSizeIsZero()
        {
            // Arrange
            var source = Enumerable.Range(0, 33).ToList();

            // Act
            var chunks = source.GetBatchesOfSize(0).ToList();

            // Assert
            chunks.Should().BeEmpty();
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ListExtensions_GetBatchesOfSize_ShouldGetEmptyListWhenChunkSizeIsLessThanZero()
        {
            // Arrange
            var source = Enumerable.Range(0, 33).ToList();

            // Act
            var chunks = source.GetBatchesOfSize(-10).ToList();

            // Assert
            chunks.Should().BeEmpty();
        }
    }
}
