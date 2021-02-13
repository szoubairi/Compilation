/*
 *  Table des symboles.c
 *
 *  Created by Janin on 12/10/10.
 *  Copyright 2010 LaBRI. All rights reserved.
 *
 */

#include "Table_des_symboles.h"
#include "Attribute.h"

#include <stdlib.h>
#include <stdio.h>

/* The storage structure is implemented as a linked chain */

/* linked element def */

typedef struct elem
{
	sid symbol_name;
	attribute symbol_value;
	struct elem *next;
} elem;

/* linked chain initial element */
static elem *storage = NULL;

int existing_symbol_in_same_block(sid symb_id, int block)
{
	elem *tracker = storage;

	/* look into the linked list for the symbol value */
	while (tracker)
	{
		if (strcmp(tracker->symbol_name, symb_id) == 0 &&
			tracker->symbol_value->num_block <= block)
			return 1;
		tracker = tracker->next;
	}

	return 0;
}

/* get the symbol value of symb_id from the symbol table */
attribute get_symbol_value(sid symb_id, bool param)
{
	elem *tracker = storage;

	/* look into the linked list for the symbol value */
	while (tracker)
	{
		if (tracker->symbol_name == symb_id && (tracker->symbol_value->num_block <= curr_block() || param))
			return tracker->symbol_value;
		tracker = tracker->next;
	}

	/* if not found does cause an error */
	fprintf(stderr, "Error : symbol %s is not a valid defined symbol\n", (char *)symb_id);
	exit(-1);
};

/* set the value of symbol symb_id to value */
attribute set_symbol_value(sid symb_id, attribute value, bool declare, bool param)
{
	if (!declare)
		value->num_block = curr_block();

	if (param)
		value->num_block = curr_block() + 1;

	elem *tracker;

	/* look for the presence of symb_id in storage */

	tracker = storage;
	while (tracker)
	{
		if (tracker->symbol_name == symb_id && (tracker->symbol_value->num_block == curr_block() || declare))
		{
			if (!declare)
				tracker->symbol_value = value;
			else
				tracker->symbol_value->reg_number = value->reg_number;
			return tracker->symbol_value;
		}
		tracker = tracker->next;
	}

	/* otherwise insert it at head of storage with proper value */

	tracker = malloc(sizeof(elem));
	tracker->symbol_name = symb_id;
	tracker->symbol_value = value;
	tracker->next = storage;
	storage = tracker;
	return storage->symbol_value;
}
