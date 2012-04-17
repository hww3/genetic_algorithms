		inherit Genome;

		ADT.Sequence TheArray =  ADT.Sequence(0);
		int TheMin = 0;
		int TheMax = 100;

array options = ({0, 5, 6, 7, 8, 9, 18 });

		public  int `<(mixed a)
		{
			ListGenome Gene1 = this;
			ListGenome Gene2 = a;
                        return (Gene2->CurrentFitness  <  Gene1->CurrentFitness);
		}


		public  int `>(mixed a)
		{
			ListGenome Gene1 = this;
			ListGenome Gene2 = a;
                        return (Gene2->CurrentFitness  > Gene1->CurrentFitness);
		}

		public  int `==(mixed a)
		{
			ListGenome Gene1 = this;
			ListGenome Gene2 = a;
                        return (Gene2->CurrentFitness  ==  Gene1->CurrentFitness);
		}



		public  void SetCrossoverPoint(int crossoverPoint)
		{
			CrossoverPoint = 	crossoverPoint;
		}

		public void create(int|void length, int|void goal)
		{
			if(!length) return;

			Length = length;
			TheMin = (int)min;
			TheMax = (int)max;
			for (int i = 0; i < Length; i++)
			{
			   int nextValue = (int)GenerateGeneValue(TheMin, TheMax);
			   TheArray->add(nextValue);
			}
		}

		public  void Initialize()
		{

		}

		public  int CanDie(float fitness)
		{
			if (CurrentFitness <= (int)(fitness * 100.0))
			{
				return 1;
			}

			return 0;
		}


		public  int CanReproduce(float fitness)
		{
			if ((int)Crypto.Random.random(100) >= (int)(fitness * 100.0))
			{
				return 1;
			}

			return 0;
		}


		static  object GenerateGeneValue(int min, int max)
		{
			return Crypto.Random.random(max-min) + min;
		}

		public  void Mutate()
		{
			MutationIndex = (int)Crypto.Random.random((int)Length);
			int val = (int)GenerateGeneValue(TheMin, TheMax);
			TheArray[MutationIndex] = val;

		}

		// This fitness function calculates the closest product sum
		private float CalculateClosestProductSum()
		{
			// fitness for a perfect number

			float sum = 0.0;
			float product = 1.0;
			for (int i = 0; i < Length; i++)
			{
				sum += (int)TheArray[i];
				product *= (int)TheArray[i];
			}
			if (product == sum)
			{
				CurrentFitness = 1.0;
			}
			else
			{
				CurrentFitness = abs(abs(1.0/(sum)) - 0.02);
			}
			
			return CurrentFitness;
		}

		public  float CalculateFitness()
		{
			CurrentFitness = CalculateClosestProductSum();
			return CurrentFitness;
		}

		public  mixed cast(string ctype)
		{
			if(ctype!="string") throw(Error.Generic("cannot cast to " + ctype + ".\n"));
			string strResult = "";
			for (int i = 0; i < Length; i++)
			{
			  strResult = strResult + ((int)TheArray[i]) + " ";
			}

			strResult += " --> " + (string)CurrentFitness;

			return strResult;
		}

		public  void CopyGeneInfo(ListGenome dest)
		{
			ListGenome theGene = dest;
			theGene->Length = Length;
			theGene->TheMin = TheMin;
			theGene->TheMax = TheMax;
		}


		public  Genome Crossover(ListGenome g)
		{
			ListGenome aGene1 =  object_program(this)();
			ListGenome aGene2 =  object_program(this)();
			g->CopyGeneInfo(aGene1);
			g->CopyGeneInfo(aGene2);


			ListGenome CrossingGene = g;
			for (int i = 0; i < CrossoverPoint; i++)
			{
				aGene1->TheArray->add(CrossingGene->TheArray[i]);
				aGene2->TheArray->add(TheArray[i]);
			}

			for (int j = CrossoverPoint; j < Length; j++)
			{
				aGene1->TheArray->add(TheArray[j]);
				aGene2->TheArray->add(CrossingGene->TheArray[j]);
			}

			// 50/50 chance of returning gene1 or gene2
			ListGenome aGene = 0;
			if ((int)Crypto.Random.random(2) == 1)			
			{
				aGene = aGene1;
			}
			else
			{
				aGene = aGene2;
			}

			return aGene;
		}


