package com.rga.pearson.model
{
	import mx.collections.ArrayCollection;

	import org.robotlegs.mvcs.Actor;

	public class CategoryModel extends Actor
	{
		public var currentSubCategory:int;

		/**
		 * Top level 'dscipline' categories
		 */
		private var categories : Array = new Array(
			"Natural Sciences",
			"Humanities",
			"Professional and Applied Sciences",
			"Formal Sciences",
			"Social Sciences"
			);

		/**
		 * Natural Sciences sub categories
		 */
		private var naturalSciences : Array = new Array(
			"Space Sciences",
			"Earth Sciences",
			"Life Sciences",
			"Chemistry",
			"Physics"
			);

		/**
		 * Humanities sub categories
		 */
		private var humanities : Array = new Array(
			"History",
			"Languages and Linguistics",
			"Literature",
			"Performing Arts",
			"Philosophy",
			"Religion",
			"Visual Arts"
			);

		/**
		 * Professions sub categories
		 */
		private var professions : Array = new Array(
			"Agriculture",
			"Architecture and Design",
			"Business",
			"Divinity",
			"Education",
			"Engineering",
			"Enviromental Studies and Forestry",
			"Family and Consumer Sciences",
			"Health Sciences",
			"Human Physical Performance and Recreation",
			"Journalism, Media Studies and Communication",
			"Law",
			"Library and Museum Studies",
			"Military Sciences",
			"Public Administration",
			"Social Work",
			"Transportation"
			);

		/**
		 * Formal Sciences sub categories
		 */
		private var formalSciences : Array = new Array(
			"Computer Sciences",
			"Logic",
			"Mathematics",
			"Statistics",
			"Systems Science"
			);

		/**
		 * Social Sciences sub categories
		 */
		private var socialSciences : Array = new Array(
			"Anthropology",
			"Archaeology",
			"Area Studies",
			"Cultural and Ethnic Studies",
			"Economics",
			"Gender and Sexuality Studies",
			"Geography",
			"Political Science",
			"Psychology",
			"Socialogy"
			);


		/**
		 * Returns top level categories
		 */
		public function getCategories():ArrayCollection
		{
			return new ArrayCollection( categories );
		}


		public function getCurrentTitle():String
		{
			return getCategories()[ currentSubCategory ];
		}


		/**
		 * Returns sub categories according to drop down list choice
		 */
		public function getSubCategories( index:int ):ArrayCollection
		{
			var subCategories:Array;
			currentSubCategory = index;

			switch( index )
			{
				case 0:
					subCategories = naturalSciences;
					break;
				case 1:
					subCategories = humanities;
					break;
				case 2:
					subCategories = professions;
					break;
				case 3:
					subCategories = formalSciences;
					break;
				case 4:
					subCategories = socialSciences;
					break;
			}
			return new ArrayCollection( subCategories );
		}
	}
}
