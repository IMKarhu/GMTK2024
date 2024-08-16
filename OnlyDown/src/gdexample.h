#ifndef GDEXAMPLE_H
#define GDEXAMPLE_H

#include <godot_cpp/classes/character_body3d.hpp>

namespace godot {

class GDExample : public CharacterBody3D {
	GDCLASS(GDExample, CharacterBody3D)

private:
	double time_passed;
	double amplitude;

protected:
	static void _bind_methods();

public:
	GDExample();
	~GDExample();
	
	int test = 10;
	void set_amplitude(const double p_amplitude);
	double get_amplitude() const;

	void _process(double delta) override;
};

}

#endif