		 int kLength = 13;
		 int kCrossover = kLength/2;
		 int kInitialPopulation = 1000;
		 int kPopulationLimit = 1000;
		 int kMin = 1;
		 int kMax = 10;
		 float  kMutationFrequency = 0.20;
		 float  kDeathFitness = 0.0;
		 float  kReproductionFitness = 0.0;

		ADT.Sequence Genomes =  ADT.Sequence(0);
		ADT.Sequence GenomeReproducers  =  ADT.Sequence(0);
		ADT.Sequence GenomeResults =  ADT.Sequence(0);
		ADT.Sequence GenomeFamily =  ADT.Sequence(0);

		int		  CurrentPopulation = kInitialPopulation;
		int		  Generation = 1;
		int	  Best2 = 1;

		program genomeType = ListGenome;

		void create(mixed ... args)
		{
			//
			// TODO: Add constructor logic here
			//
			for  (int i = 0; i < kInitialPopulation; i++)
			{
				Genome aGenome =  createGenome(@args);
				aGenome->SetCrossoverPoint(kCrossover);
				aGenome->CalculateFitness();
				Genomes->add(aGenome);
			}

		}

public Genome createGenome(mixed ... args)
{
   return genomeType(kLength, kMin, kMax);
}
		private void Mutate(Genome aGene)
		{
			if (Crypto.Random.random(100) < (int)(kMutationFrequency * 100.0))
			{
			  	aGene->Mutate();
			}
		}

		public void NextGeneration()
		{
			// increment the generation;
			Generation++; 


			// check who can die
			foreach(Genomes;int i; Genome g)
			{
				if  (!g || g->CanDie(kDeathFitness))
				{
					Genomes->_remove_element(i);
					i--;
				}
			}


			// determine who can reproduce
			GenomeReproducers->clear();
			GenomeResults->clear();
			for  (int i = 0; i < sizeof(Genomes); i++)
			{
				if ((Genomes[i])->CanReproduce(kReproductionFitness))
				{
					GenomeReproducers->add(Genomes[i]);			
				}
			}
			
			// do the crossover of the genes and add them to the population
			DoCrossover(GenomeReproducers);

			Genomes = ADT.Sequence((array)GenomeResults);

			// mutate a few genes in the  population
			foreach(Genomes;; Genome g)
			{
				Mutate(g);
			}

			// calculate fitness of all the genes
			foreach(Genomes;; Genome g)
			{
				g->CalculateFitness();
			}


//			Genomes = ADT.Sequence(sort((array) Genomes));

			// kill all the genes above the population limit
			if (sizeof(Genomes) > kPopulationLimit)
                        {
                           for(int z = kPopulationLimit; z < sizeof(Genomes); z++)
				Genomes->_remove_element(z);
			}
			CurrentPopulation = sizeof(Genomes);
			
		}

		public void CalculateFitnessForAll(ADT.Sequence genes)
		{
			foreach(genes;; Genome lg)
			{
			  lg->CalculateFitness();
			}
		}

		public void DoCrossover(ADT.Sequence genes)
		{
			ADT.Sequence GeneMoms =  ADT.Sequence(0);
			ADT.Sequence GeneDads =  ADT.Sequence(0);

			for (int i = 0; i < sizeof(genes); i++)
			{
				// randomly pick the moms and dad's
				if (Crypto.Random.random(100) % 2 > 0)
				{
					GeneMoms->add(genes[i]);
				}
				else
				{
					GeneDads->add(genes[i]);
				}
			}

			//  now make them equal
			if (sizeof(GeneMoms) > sizeof(GeneDads))
			{
				while (sizeof(GeneMoms) > sizeof(GeneDads))
				{
					GeneDads->add(GeneMoms[sizeof(GeneMoms) - 1]);
					GeneMoms->_remove_element(sizeof(GeneMoms) - 1);
				}

				if (sizeof(GeneDads) > sizeof(GeneMoms))
				{
					GeneDads->_remove_element(sizeof(GeneDads) - 1); // make sure they are equal
				}

			}
			else
			{
				while (sizeof(GeneDads) > sizeof(GeneMoms))
				{
					GeneMoms->add(GeneDads[sizeof(GeneDads) - 1]);
					GeneDads->_remove_element(sizeof(GeneDads) - 1);
				}

				if (sizeof(GeneMoms) > sizeof(GeneDads))
				{
					GeneMoms->_remove_element(sizeof(GeneMoms) - 1); // make sure they are equal
				}
			}

			// now cross them over and add them according to fitness
			for (int i = 0; i < sizeof(GeneDads); i ++)
			{
				// pick best 2 from parent and children
				Genome babyGene1 = (GeneDads[i])->Crossover(GeneMoms[i]);
			   	Genome babyGene2 = (GeneMoms[i])->Crossover(GeneDads[i]);
			
				GenomeFamily->clear();
				GenomeFamily->add(GeneDads[i]);
				GenomeFamily->add(GeneMoms[i]);
				GenomeFamily->add(babyGene1);
				GenomeFamily->add(babyGene2);
				CalculateFitnessForAll(GenomeFamily);
				GenomeFamily = ADT.Sequence(sort((array)GenomeFamily));

				if (Best2)
				{
					// if Best2 is true, add top fitness genes
					GenomeResults->add(GenomeFamily[0]);					
					GenomeResults->add(GenomeFamily[1]);					

				}
				else
				{
					GenomeResults->add(babyGene1);
					GenomeResults->add(babyGene2);
				}
			}

		}

		public void WriteNextGeneration()
		{
			// just write the top 20
			write("Generation %O\n", Generation);
			for  (int i = 0; i <  CurrentPopulation ; i++)
			{
				write((string)(Genomes[i]) + "\n");
			}

			write("Hit the enter key to continue...\n");
			Stdio.stdin.gets();
		}

