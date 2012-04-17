
		inherit ListGenome;

		ADT.Sequence TheArray =  ADT.Sequence(0);
		int TheMin = 0;
		int TheMax = 0;

array options = ({0, 0, 5, 6, 7, 8, 9, 9, 18, 18, 18, 18});

		public  int `<(mixed a)
		{
			ListGenome Gene1 = this;
			ListGenome Gene2 = a;

                        return (Gene2->CurrentFitness  <  Gene1->CurrentFitness) || (Gene2->CurrentFitness == Gene1->CurrentFitness && Gene1->count_units() < Gene2->count_units()) ;
		}

		public  int `>(mixed a)
		{
			ListGenome Gene1 = this;
			ListGenome Gene2 = a;
                        return (Gene2->CurrentFitness  >  Gene1->CurrentFitness) || (Gene2->CurrentFitness == Gene1->CurrentFitness && Gene1->count_units() > Gene2->count_units()) ;
		}

		public  int `==(mixed a)
		{
			ListGenome Gene1 = this;
			ListGenome Gene2 = a;
                        return (Gene2->CurrentFitness  ==  Gene1->CurrentFitness) && Gene2->count_units == Gene1->count_units();
		}

int count_units()
{
  int res;

  foreach(TheArray;; int val)
    if(val) res++;

  return res;  
}

		public void create(int|void length, int|void goal)
		{
			if(!length) return;

			Length = length;
			TheMax = (int)goal;
			for (int i = 0; i < Length; i++)
			{
			   int nextValue = (int)GenerateGeneValue();
			   TheArray->add(nextValue);
			}
		}


		public  object GenerateGeneValue()
		{
			return options[(int)Crypto.Random.random(sizeof(options))];
		}

		public  void Mutate()
		{
			MutationIndex = (int)Crypto.Random.random((int)Length);
			int val = (int)GenerateGeneValue();
			TheArray[MutationIndex] = val;

		}

		// This fitness function calculates the closest product sum
		private float CalculateClosestProductSum()
		{
			// fitness for a perfect number
			int sum = 0;
			for (int i = 0; i < Length; i++)
			{
				sum += (int)TheArray[i];
			}
			if (TheMax == sum)
			{
				CurrentFitness = 0.7;
				CurrentFitness += (((float)(Length - count_units())/(float)Length) * 0.3);
			}
			else if(sum > TheMax)
			{
				CurrentFitness = 0.2;
			}
			else
			{
				CurrentFitness = (1 - abs((TheMax-(float)sum)/(TheMax - (TheMax/18)))) * 0.7;
			}
			
			return CurrentFitness;
		}

		public  float CalculateFitness()
		{
			CurrentFitness = CalculateClosestProductSum();
			return CurrentFitness;
		}


		public  void CopyGeneInfo(ListGenome dest)
		{
			ListGenome theGene = dest;
			theGene->Length = Length;
			theGene->TheMin = TheMin;
			theGene->TheMax = TheMax;
		}


               public  mixed cast(string ctype)
                {
                        if(ctype!="string") throw(Error.Generic("cannot cast to " + ctype + ".\n"));
                        string strResult = "";  
int sum = 0;
                        for (int i = 0; i < Length; i++)
                        {
sum += (int) TheArray[i];
                          strResult = strResult + ((int)TheArray[i]) + " ";
                        }
                        
                        strResult += sprintf(" --> %d %s", sum, (string)CurrentFitness);
                        
                        return strResult;
                }
