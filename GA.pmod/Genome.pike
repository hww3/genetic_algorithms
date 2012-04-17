		public int Length;
		public int  CrossoverPoint;
		public int  MutationIndex;
		public float CurrentFitness = 0.0;

	        public void Initialize();
	        public void Mutate();
	        public Genome Crossover(Genome g);
	        public optional object GenerateGeneValue();
	        public void SetCrossoverPoint(int crossoverPoint);
	        public float CalculateFitness();
	        public int  CanReproduce(float fitness);
	        public int  CanDie(float fitness);
	        public void	CopyGeneInfo(Genome g);

		
		public int CompareTo(object a);


