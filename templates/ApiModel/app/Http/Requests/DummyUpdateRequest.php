<?php

namespace App\Http\Requests;

use App\Models\Dummy;

class DummyUpdateRequest extends ApiResourceRequest
{
    /** @inheritDoc */
    public function rules(): array
    {
        return
            [
                'name' => ['min:3'],
                //TODO: Complete definition
            ];
    }

    protected function getModel(): string
    {
        return Dummy::class;
    }
}
