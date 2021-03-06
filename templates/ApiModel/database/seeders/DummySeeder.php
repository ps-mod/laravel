<?php

namespace Database\Seeders;

use App\Models\Dummy;
use Illuminate\Database\Seeder;

class DummySeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run(): void
    {
        Dummy::factory(50)->create();
    }
}
