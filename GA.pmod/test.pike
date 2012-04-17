class linePopulation
{
  inherit Population;
  program genomeType = LineGenome;

  Genome createGenome(mixed ... args)
  {
    return genomeType(20, 72);
  }
}

int main()
{
  Population TestPopulation = linePopulation();

  TestPopulation->WriteNextGeneration();



			for (int i = 0; i < 1000; i++)
			{
				TestPopulation->NextGeneration();
			}
  
				TestPopulation->WriteNextGeneration();
return 0;
}
